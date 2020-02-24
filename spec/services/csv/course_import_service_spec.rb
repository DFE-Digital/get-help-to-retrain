require 'rails_helper'

RSpec.describe Csv::CourseImportService do
  subject(:importer) { described_class.new }

  let(:folder) { Rails.root.join('spec', 'fixtures', 'files', 'csv').to_s }

  describe '#import' do
    it 'deletes existing course records' do
      create(:csv_course, name: 'Old course')
      importer.import(folder)

      expect(Csv::Course.where(name: 'Old course')).to be_empty
    end

    it 'deletes existing provider records' do
      create(:provider, name: 'Old provider')
      importer.import(folder)

      expect(Csv::Provider.where(name: 'Old provider')).to be_empty
    end

    it 'deletes existing venue records' do
      create(:venue, name: 'Old venue')
      importer.import(folder)

      expect(Csv::Venue.where(name: 'Old venue')).to be_empty
    end

    it 'deletes existing opportunity records' do
      create(:opportunity, url: 'www.old-url.com')
      importer.import(folder)

      expect(Csv::Opportunity.where(url: 'www.old-url.com')).to be_empty
    end

    it 'deletes existing opportunity start date records' do
      date = Date.parse('6-6-666')
      create(:opportunity_start_date, start_date: date)
      importer.import(folder)

      expect(Csv::OpportunityStartDate.where(start_date: date)).to be_empty
    end

    it 'deletes existing course lookup records' do
      create(:course_lookup, subject: 'old subject')
      importer.import(folder)

      expect(Csv::CourseLookup.where(subject: 'old subject')).to be_empty
    end

    it 'creates csv providers' do
      expect { importer.import(folder) }.to change(Csv::Provider, :count).by(4)
    end

    it 'creates csv venues' do
      expect { importer.import(folder) }.to change(Csv::Venue, :count).by(4)
    end
  end

  describe '#import_stats' do
    before { importer.import(folder) }

    it 'reports statistics on completion' do
      expect(importer.import_stats).to eq(providers_total: 4)
    end
  end
end
