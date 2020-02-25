require 'rails_helper'

RSpec.describe Csv::Persistor::OpportunityStartDate do
  let(:row) do
    CSV.read(
      Rails.root.join('spec', 'fixtures', 'files', 'csv', described_class::FILENAME),
      headers: true
    ).first
  end

  describe '#persist!' do
    it 'sets the correct attributes for an opportunity start date' do
      create(:opportunity, external_opportunities_id: 4_531_489)

      described_class.new(row).persist!
      expect(Csv::OpportunityStartDate.first).to have_attributes(
        start_date: Date.parse('2019-09-01')
      )
    end

    it 'is linked to correct opportunity' do
      opportunity = create(:opportunity, external_opportunities_id: 4_531_489)
      described_class.new(row).persist!

      expect(opportunity.reload.opportunity_start_dates.count).to eq(1)
    end

    it 'persists opportunity start dates not linked to any opportunity' do
      expect { described_class.new(row).persist! }.to change(Csv::OpportunityStartDate, :count).by(1)
    end
  end
end
