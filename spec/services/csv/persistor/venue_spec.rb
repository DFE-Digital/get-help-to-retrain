require 'rails_helper'

RSpec.describe Csv::Persistor::Venue do
  let(:row) do
    CSV.read(
      Rails.root.join('spec', 'fixtures', 'files', 'csv', described_class::FILENAME),
      headers: true
    ).first
  end

  describe '#persist!' do
    it 'sets the correct attributes for a venue' do
      provider = create(:provider, external_provider_id: 301_751)
      described_class.new(row).persist!

      expect(Csv::Venue.first).to have_attributes(
        external_venue_id: 3_041_969,
        name: 'MI SKILLS DEVELOPMENT CENTRE - BRIXTON',
        address_line_1: '47a Bellefields Road',
        address_line_2: 'Brixton',
        town: 'London',
        county: nil,
        postcode: 'SW9 9UH',
        phone: '02075016450',
        email: 'info@micomputsolutions.co.uk',
        url: 'http://www.micomputsolutions.co.uk',
        provider: provider
      )
    end

    it 'is linked to correct provider' do
      provider = create(:provider, external_provider_id: 301_751)
      described_class.new(row).persist!

      expect(provider.venues.count).to eq(1)
    end

    it 'fails if no provider found' do
      expect { described_class.new(row).persist! }.to raise_exception(ActiveRecord::RecordInvalid)
    end
  end
end
