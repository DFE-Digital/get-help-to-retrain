require 'rails_helper'

RSpec.describe Csv::Persistor::Provider do
  let(:folder) { Rails.root.join('spec', 'fixtures', 'files', 'csv').to_s }

  describe '#persist!' do
    it 'persists all records in csv' do
      expect { described_class.new(folder).persist! }.to change(Csv::Provider, :count).by(4)
    end

    it 'sets the correct attributes for a provider' do
      described_class.new(folder).persist!
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
