require 'rails_helper'

RSpec.describe Csv::Persistor::Provider do
  let(:row) do
    CSV.read(
      Rails.root.join('spec', 'fixtures', 'files', 'csv', described_class::FILENAME),
      headers: true
    ).first
  end

  describe '#persist!' do
    it 'sets the correct attributes for a provider' do
      described_class.new(row).persist!

      expect(Csv::Provider.first).to have_attributes(
        external_provider_id: 301_751,
        ukprn: 10_018_328,
        name: 'MI COMPUTSOLUTIONS INCORPORATED',
        address_line_1: '47A Bellefields Road',
        address_line_2: 'Brixton',
        town: 'London',
        county: nil,
        postcode: 'SW9 9UH',
        phone: '02075016450',
        email: 'info@micomputsolutions.co.uk',
        url: 'http://www.micomputsolutions.co.uk'
      )
    end
  end
end
