module Flipflop
  module Strategies
    class SplitClientStrategy < AbstractStrategy
      class << self
        def default_description
          'External configuration via split.io client'
        end
      end

      def initialize(**options)
        @client = factory(options).client

        super(**options)
      end

      def enabled?(feature)
        @client.get_treatment('user', feature.to_s) == 'on'
      end

      private

      def factory(options)
        api_key = options.delete(:api_key)
        path = options.delete(:path)
        raise "#{self} path option is only permitted in localhost mode" if path.present? && api_key != 'localhost'

        SplitIoClient::SplitFactoryBuilder.build api_key, split_file: path
      end
    end
  end
end
