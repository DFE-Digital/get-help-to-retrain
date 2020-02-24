module Csv
  module Persistor
    class Provider
      FILENAME = 'C_PROVIDERS.csv'.freeze

      attr_reader :path

      def initialize(folder)
        @path = File.join(folder, FILENAME)
      end

      def persist!
        CSV.foreach(path, headers: true) do |row|
          Csv::Provider.create!(
            attributes_for(row)
          )
        end
      end

      private

      def attributes_for(row) # rubocop:disable Metrics/MethodLength
        {
          external_provider_id: row['PROVIDER_ID'],
          ukprn: row['UKPRN'],
          name: row['PROVIDER_NAME'],
          address_line_1: row['ADDRESS_1'],
          address_line_2: row['ADDRESS_2'],
          town: row['TOWN'],
          county: row['COUNTY'],
          postcode: row['POSTCODE'],
          phone: row['PHONE'],
          email: row['EMAIL'],
          url: row['WEBSITE']
        }
      end
    end
  end
end
