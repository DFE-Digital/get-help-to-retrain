module Flipflop
  module Strategies
    class SplitClientStrategy < AbstractStrategy
      attr_reader :client
      class << self
        def default_description
          'External configuration via split.io client'
        end
      end

      def initialize(**options)
        @client = factory(options)
        super(**options)
      end

      def enabled?(feature)
        return false unless client

        client.get_treatment('user', feature.to_s) == 'on'
      end

      private

      def factory(options)
        api_key = options.delete(:api_key)
        path = options.delete(:path)
        raise "#{self} path option is only permitted in localhost mode" if path.present? && api_key != 'localhost'

        SplitIoClient::SplitFactoryBuilder.build(api_key, split_file: path).client
      rescue StandardError => e
        Rails.logger.error("SplitIO error: #{e.inspect}")
        nil
      end
    end
  end
end
