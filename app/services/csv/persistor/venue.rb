module Csv
  module Persistor
    class Venue
      FILENAME = 'C_VENUES.csv'.freeze

      attr_reader :path

      def initialize(folder)
        @path = File.join(folder, FILENAME)
      end

      def persist!
        CSV.foreach(path, headers: true) do |row|
          attributes_for(row)
        end
      end

      private

      def attributes_for(row) # rubocop:disable Metrics/MethodLength
        Csv::Venue.create!(
          external_venue_id: row['VENUE_ID'],
          name: row['VENUE_NAME'],
          address_line_1: row['ADDRESS_1'],
          address_line_2: row['ADDRESS_2'],
          town: row['TOWN'],
          county: row['COUNTY'],
          postcode: row['POSTCODE'],
          phone: row['PHONE'],
          email: row['EMAIL'],
          url: row['WEBSITE'],
          provider: Csv::Provider.find_by(external_provider_id: row['PROVIDER_ID'])
        )
      end
    end
  end
end
