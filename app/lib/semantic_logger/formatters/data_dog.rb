# This can be attributed to https://github.com/flipgroup/data-dog-semantic-logger/
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
          http: http_data,
          error: error,
          network: network,
          db: database_info,
          usr: user_info,
          syslog: syslog
        }.merge(named_tags)
      end

      def network # rubocop:disable Metrics/MethodLength
        return {} if request.nil?

        {
          client: {
            ip: try(request, :ip),
            port: try(request, :port)
          },
          destination: {
            ip: try(request, :remote_ip),
            port: try(request, :server_port)
          }
        }
      end

      def http_data
        return {} if request.nil?

        {
          url: try(request, :original_url),
          method: try(request, :method),
          referer: try(request, :referer),
          request_id: try(request, :request_id),
          useragent: try(request, :user_agent),
          url_details: url_details
        }
      end

      def url_details
        return {} unless url

        {
          host: try(url, :host),
          port: try(url, :port),
          path: try(url, :path),
          queryString: try(url, :query),
          scheme: try(url, :scheme)
        }
      end

      def logger
        return {} if log.nil?

        {
          name: 'SemanticLogger',
          thread_name: try(log, :thread_name),
          method_name: try(log, :name)
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
          id: try(user, :id),
          name: try(user, :name),
          email: try(user, :email)
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
        return unless try(local_time, :to_time)

        (local_time.to_time.utc.to_f * 1000).to_i
      end

      def time?
        !time.nil?
      end

      def appname
        Rails.application.class.module_parent_name
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
        return unless sql?

        log.payload[:sql].to_s
      end

      private

      def init_class_by_named_tags
        @request = log.named_tags[:request]
        @user = log.named_tags[:user]
        @database = log.named_tags[:database]
      end

      def user_agent
        return if request.nil?

        user_agent = request.user_agent
        return if user_agent.nil?

        ::UserAgent.parse(user_agent.to_s)
      rescue ArgumentError => _e
        nil
      end

      def url
        return if request.nil?

        original_url = request.original_url
        return if original_url.nil?

        ::URI.parse(original_url.to_s)
      rescue URI::InvalidURIError => _e
        nil
      end

      def try(object, property)
        return nil unless object&.respond_to?(property)

        object.send(property).to_s
      end
    end
  end
end
