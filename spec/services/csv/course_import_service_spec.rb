require 'rails_helper'

RSpec.describe Csv::CourseImportService do
  subject(:importer) { described_class.new }

  let(:folder) { Rails.root.join('spec', 'fixtures', 'csv').to_s }


  describe '#import' do
    it 'creates course details' do
      importer.import(path)
      expect(course).to have_attributes(
        name: 'Basic English', provider: 'Acme Training Inc.', url: 'english url',
        address_line_1: 'Address 1', address_line_2: 'Address 2', town: 'London',
        county: 'Londonshire', postcode: 'NW11 8QE', email: nil, topic: 'english',
        phone_number: '01 811 8055', active: true, latitude: 0.1, longitude: 0.2
      )
    end
  end

  describe '#import_stats' do
    before { importer.import(path) }

    it 'reports statistics on completion' do
      expect(importer.import_stats).to eq({})
    end
  end
end
