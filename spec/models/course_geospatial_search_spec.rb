require 'rails_helper'

RSpec.describe CourseGeospatialSearch do
  describe '#find_courses' do
    it 'returns nothing if no postcode entered' do
      search = described_class.new(postcode: nil, topic: nil, distance: 5)
      expect(search.find_courses).to be_empty
    end

    it 'returns nothing if empty postcode entered' do
      search = described_class.new(postcode: '', topic: nil, distance: 5)
      expect(search.find_courses).to be_empty
    end

    it 'returns courses ordered by distance to postcode entered' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )

      course1 = create(:course, latitude: 0.1, longitude: 1.001)
      course2 = create(:course, latitude: 0.1, longitude: 1.003)
      course3 = create(:course, latitude: 0.1, longitude: 1.002)

      search = described_class.new(postcode: 'NW6 8ET', distance: 2, topic: nil)

      expect(search.find_courses).to eq(
        [course1, course3, course2]
      )
    end

    it 'scopes courses by topic if topic defined' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )

      create(:course, latitude: 0.1, longitude: 1, topic: 'maths')
      course2 = create(:course, latitude: 0.1, longitude: 1, topic: 'english')
      create(:course, latitude: 0.1, longitude: 1, topic: 'maths')
      search = described_class.new(postcode: 'NW6 8ET', distance: 2, topic: 'english')

      expect(search.find_courses).to contain_exactly(
        course2
      )
    end

    it 'limits courses to distance entered from postcode' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )

      course1 = create(:course, latitude: 0.1, longitude: 1.001)
      create(:course, latitude: 0.1, longitude: 1.2)
      create(:course, latitude: 0.1, longitude: 1.3)
      search = described_class.new(postcode: 'NW6 8ET', distance: 1, topic: nil)

      expect(search.find_courses).to eq(
        [course1]
      )
    end

    it 'returns nothing if postcode entered is too far' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )

      create(:course, latitude: 0.1, longitude: 2)
      create(:course, latitude: 0.1, longitude: 3)
      create(:course, latitude: 0.1, longitude: 4)
      search = described_class.new(postcode: 'NW6 8ET', distance: 10, topic: nil)

      expect(search.find_courses).to be_empty
    end
  end

  describe 'validation' do
    it 'is invalid if postcode entered is invalid' do
      search = described_class.new(postcode: 'NW6 8E', distance: nil, topic: nil)

      expect(search).not_to be_valid
    end

    it 'is invalid if postcode is not entered' do
      search = described_class.new(postcode: nil, distance: nil, topic: nil)

      expect(search).not_to be_valid
    end

    it 'is invalid if postcode is valid but does not exist' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => nil }]
      )

      search = described_class.new(postcode: 'NW6 8ET')
      expect(search).not_to be_valid
    end

    it 'raises error if API for geocoding not available' do
      allow(Geocoder).to receive(:coordinates).and_raise(Geocoder::ServiceUnavailable)
      search = described_class.new(postcode: 'NW6 8ET', distance: nil, topic: nil)

      expect { search.find_courses }.to raise_error(described_class::GeocoderAPIError)
    end
  end
end
