require 'json'
require 'useragent'
require 'uri'

# Log message structure:
# https://docs.datadoghq.com/logs/processing/attributes_naming_convention/
# {
#   network: {
#     client: {
#       ip: <string>,
#       port: <string>
#     },
#     destination: {
#       ip: <string>,
#       port: <string>
#     },
#     bytes_read: <number>,
#     bytes_written: <number>
#   },
#   http: {
#     url: <string>,
#     status_code: <number>,
#     method: <string>,
#     referer: <string>,
#     request_id: <string>,
#     useragent: <string>,
#     url_details: {
#       host: <string>,
#       port: <number>,
#       path: <string>,
#       queryString: <object>,
#       scheme: <string>
#     },
#     useragent_details: {
#       os: {
#         family: <string>
#       },
#       browser: {
#         family: <string>
#       },
#       device: {
#         family: <string>
#       }
#     }
#   },
#   logger: {
#     name: <string>,
#     thread_name: <string>,
#     method_name: <string>
#   },
#   error: {
#     kind: <string>,
#     message: <string>,
#     stack: <string>
#   },
#   db: {
#     instance: <string>,
#     statement: <string>,
#     operation: <string>,
#     user: <string>
#   },
#   duration: <number>,
#   user: {
#     id: <string>,
#     name: <string>,
#     email: <string>
#   },
#   syslog: {
#     hostname: <string>,
#     appname: <string>,
#     severity: <string>,
#     timestamp: <string>,
#     env: <string>
#   }
# }
module SemanticLogger
  module Formatters
    class DataDog < Default # rubocop:disable Metrics/ClassLength
      attr_reader :request, :user, :database

      def call(log, logger)
        self.log = log
        self.logger = logger
        init_class_by_named_tags
        build_message.to_json
      end

      def build_message # rubocop:disable Metrics/MethodLength
        {
          level: level,
          message: message,
          logger: logger,
          http: http,
          error: error,
          network: network,
          db: database_info,
          usr: user_info,
          syslog: syslog
        }.merge(named_tags)
      end

      def network # rubocop:disable Metrics/MethodLength
        return {} unless request.present?

        {
          client: {
            ip: request.ip,
            port: request.port
          },
          destination: {
            ip: request.remote_ip,
            port: request.server_port
          }
        }
      end

      def http # rubocop:disable Metrics/MethodLength
        return http_data unless user_agent.present?

        http_data.merge(
          useragent_details: {
            os: {
              family: user_agent.application.to_s
            },
            browser: {
              family: "#{user_agent.webkit} #{user_agent.browser}"
            },
            device: {
              family: user_agent.platform
            }
          }
        )
      end

      def http_data
        return {} unless request.present?

        {
          url: request.original_url,
          method: request.method,
          referer: request.referer,
          request_id: request.request_id,
          useragent: request.user_agent,
          url_details: url_details
        }
      end

      def url_details
        return {} unless url

        {
          host: url.host,
          port: url.port,
          path: url.path,
          queryString: url.query,
          scheme: url.scheme
        }
      end

      def logger
        return {} unless log.present?

        {
          name: 'SemanticLogger',
          thread_name: log.thread_name,
          method_name: log.name
        }
      end

      def error
        exception = log.exception
        return {} unless exception

        {
          stack: (exception.backtrace || []).join("\n"),
          message: exception.message.to_s,
          kind: (exception.class.name || 'UnknownException').to_s
        }
      end

      def database_info
        { statement: sql.to_s }
      end

      def user_info
        return {} if user.nil?

        {
          id: user.id,
          name: user.name,
          email: user.email
        }
      end

      def syslog
        local_syslog = {
          hostname: hostname,
          appname: appname,
          severity: level,
          env: environment
        }
        local_syslog[:timestamp] = time.to_s if time?
        local_syslog[:appname] = appname if appname?
        local_syslog
      end

      def time
        local_time = log.time
        return unless local_time.to_time

        (local_time.to_time.utc.to_f * 1000).to_i
      end

      def time?
        !time.nil?
      end

      def appname
        ENV['APP_NAME'].to_s
      end

      def appname?
        !appname.nil?
      end

      def named_tags
        tags = log.named_tags || {}
        log.named_tags.delete(:request)
        log.named_tags.delete(:user)
        log.named_tags.delete(:database)
        tags
      end

      def level
        severity = log.level.to_s.downcase
        severity == 'fatal' ? 'crit' : severity
      end

      def message
        message = log.message.to_s
        message << log.payload.inspect if log.payload && !sql?
        message
      end

      def hostname
        return 'unknown' unless request.respond_to?(:env)

        request.env['SERVER_NAME']
      end

      def environment
        ENV['RAILS_ENV'] || 'unknown'
      end

      def sql?
        return false unless log.payload

        true
      end

      def sql
        return nil unless sql?

        log.payload[:sql].to_s
      end

      private

      def init_class_by_named_tags
        @request = log.named_tags[:request]
        @user = log.named_tags[:user]
        @database = log.named_tags[:database]
      end

      def user_agent
        return nil if request.nil?

        user_agent = request.user_agent
        return if user_agent.nil?

        ::UserAgent.parse(user_agent.to_s)
      rescue ArgumentError => _e
        nil
      end

      def url
        return nil if request.nil?

        original_url = request.original_url
        return if original_url.nil?

        ::URI.parse(original_url.to_s)
      rescue URI::InvalidURIError => _e
        nil
      end
    end
  end
end
