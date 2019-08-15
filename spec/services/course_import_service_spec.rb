require 'rails_helper'

RSpec.describe CourseImportService do
  subject(:importer) { described_class.new }

  let(:path) { Rails.root.join('spec', 'fixtures', 'files', 'courses.xlsx').to_s }
  let(:course) { Course.first }

  before do
    Geocoder::Lookup::Test.add_stub('NW11 8QE', [{ 'coordinates' => [0.1, 0.2] }])
    Geocoder::Lookup::Test.add_stub('NW6 8ET', [{ 'coordinates' => [] }])
  end

  describe '#import' do
    it 'raises error if invalid filename' do
      expect { importer.import('foo.xlsx') }.to raise_exception(IOError)
    end

    it 'does not raise error with valid filename' do
      expect { importer.import(path) }.not_to raise_exception
    end

    it 'creates courses' do
      importer.import(path)
      expect(course).to have_attributes(title: 'Basic English', provider: 'Acme Training Inc.', url: 'english url',
                                        address_line_1: 'Address 1', address_line_2: 'Address 2', town: 'London',
                                        county: 'Londonshire', postcode: 'NW11 8QE', email: nil, topic: 'english',
                                        phone_number: '01 811 8055', active: true, latitude: 0.1, longitude: 0.2)
    end
  end

  describe '#import_stats' do
    before { importer.import(path) }

    it 'reports statistics on completion' do
      expect(importer.import_stats).to eq(
        courses_total: 2,
        courses_with_geocoding: 1,
        courses_without_geocoding: 1,
        errors: 1
      )
    end
  end
end
