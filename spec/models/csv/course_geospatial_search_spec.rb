require 'rails_helper'

RSpec.describe Csv::CourseGeospatialSearch do
  describe '#find_courses' do
    it 'returns nothing if no postcode entered' do
      search = described_class.new(postcode: nil, topic: nil, options: { distance: 5 })
      expect(search.find_courses).to be_empty
    end

    it 'returns nothing if empty postcode entered' do
      search = described_class.new(postcode: '', topic: nil, options: { distance: 5 })
      expect(search.find_courses).to be_empty
    end

    it 'returns courses ordered by distance to postcode entered' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )

      course_lookup1 = create(:course_lookup, latitude: 0.1, longitude: 1.001)
      course_lookup2 = create(:course_lookup, latitude: 0.1, longitude: 1.003)
      course_lookup3 = create(:course_lookup, latitude: 0.1, longitude: 1.002)

      search = described_class.new(postcode: 'NW6 8ET', topic: nil, options: { distance: 2 })

      expect(search.find_courses).to eq(
        [course_lookup1, course_lookup3, course_lookup2]
      )
    end

    it 'scopes courses by topic if topic defined' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )

      create(:course_lookup, latitude: 0.1, longitude: 1, subject: 'maths')
      course_lookup2 = create(:course_lookup, latitude: 0.1, longitude: 1, subject: 'english')
      create(:course_lookup, latitude: 0.1, longitude: 1, subject: 'maths')
      search = described_class.new(postcode: 'NW6 8ET', topic: 'english', options: { distance: 2 })

      expect(search.find_courses).to contain_exactly(
        course_lookup2
      )
    end

    it 'limits courses to distance entered from postcode' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )

      course_lookup1 = create(:course_lookup, latitude: 0.1, longitude: 1.001)
      create(:course_lookup, latitude: 0.1, longitude: 1.2)
      create(:course_lookup, latitude: 0.1, longitude: 1.3)
      search = described_class.new(postcode: 'NW6 8ET', topic: nil, options: { distance: 1 })

      expect(search.find_courses).to eq(
        [course_lookup1]
      )
    end

    it 'defaults to distance 20 miles if no distance passed in' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )

      course_lookup1 = create(:course_lookup, latitude: 0.1, longitude: 1.2)
      create(:course_lookup, latitude: 0.1, longitude: 2)
      create(:course_lookup, latitude: 0.1, longitude: 3)
      search = described_class.new(postcode: 'NW6 8ET', topic: nil)

      expect(search.find_courses).to eq(
        [course_lookup1]
      )
    end

    it 'returns nothing if postcode entered is too far' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )

      create(:course_lookup, latitude: 0.1, longitude: 2)
      create(:course_lookup, latitude: 0.1, longitude: 3)
      create(:course_lookup, latitude: 0.1, longitude: 4)
      search = described_class.new(postcode: 'NW6 8ET', topic: nil, options: { distance: 10 })

      expect(search.find_courses).to be_empty
    end

    it 'returns all course lookups if hours selected is All' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )
      course_lookup1 = create(:course_lookup, subject: 'english', hours: nil, latitude: 0.1, longitude: 1.0)
      course_lookup2 = create(:course_lookup, subject: 'english', hours: 'Flexible', latitude: 0.1, longitude: 1.0)
      course_lookup3 = create(:course_lookup, subject: 'english', hours: 'Not known', latitude: 0.1, longitude: 1.0)
      search = described_class.new(
        postcode: 'NW6 8ET',
        topic: 'english',
        options: {
          hours: 'All'
        }
      )

      expect(search.find_courses).to contain_exactly(
        course_lookup3, course_lookup2, course_lookup1
      )
    end

    it 'returns course lookup with hours if delivery type selected' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )
      create(:course_lookup, subject: 'english', hours: nil, latitude: 0.1, longitude: 1.0)
      course_lookup2 = create(:course_lookup, subject: 'english', hours: 'Flexible', latitude: 0.1, longitude: 1.0)
      create(:course_lookup, subject: 'english', hours: 'Part time', latitude: 0.1, longitude: 1.0)
      search = described_class.new(
        postcode: 'NW6 8ET',
        topic: 'english',
        options: {
          hours: 'Flexible'
        }
      )

      expect(search.find_courses).to contain_exactly(
        course_lookup2
      )
    end

    it 'returns all course lookups if no hours selected' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )
      course_lookup1 = create(:course_lookup, subject: 'english', hours: nil, latitude: 0.1, longitude: 1.0)
      course_lookup2 = create(:course_lookup, subject: 'english', hours: 'Flexible', latitude: 0.1, longitude: 1.0)
      course_lookup3 = create(:course_lookup, subject: 'english', hours: 'Part time', latitude: 0.1, longitude: 1.0)
      search = described_class.new(
        postcode: 'NW6 8ET',
        topic: 'english'
      )

      expect(search.find_courses).to contain_exactly(
        course_lookup1, course_lookup2, course_lookup3
      )
    end

    it 'returns all course lookups if delivery type selected is All' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )
      course_lookup1 = create(:course_lookup, subject: 'english', delivery_type: nil, latitude: 0.1, longitude: 1.0)
      course_lookup2 = create(:course_lookup, subject: 'english', delivery_type: 'Classroom based', latitude: 0.1, longitude: 1.0)
      course_lookup3 = create(:course_lookup, subject: 'english', delivery_type: 'Not known', latitude: 0.1, longitude: 1.0)
      search = described_class.new(
        postcode: 'NW6 8ET',
        topic: 'english',
        options: {
          delivery_type: 'All'
        }
      )

      expect(search.find_courses).to contain_exactly(
        course_lookup1, course_lookup2, course_lookup3
      )
    end

    it 'returns course lookup with delivery type if delivery type selected' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )
      create(:course_lookup, subject: 'english', delivery_type: nil, latitude: 0.1, longitude: 1.0)
      course_lookup2 = create(:course_lookup, subject: 'english', delivery_type: 'Classroom based', latitude: 0.1, longitude: 1.0)
      create(:course_lookup, subject: 'english', delivery_type: 'Not known', latitude: 0.1, longitude: 1.0)
      search = described_class.new(
        postcode: 'NW6 8ET',
        topic: 'english',
        options: {
          delivery_type: 'Classroom based'
        }
      )

      expect(search.find_courses).to contain_exactly(
        course_lookup2
      )
    end

    it 'returns all course lookups if no delivery type selected' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )
      course_lookup1 = create(:course_lookup, subject: 'english', delivery_type: nil, latitude: 0.1, longitude: 1.0)
      course_lookup2 = create(:course_lookup, subject: 'english', delivery_type: 'Classroom based', latitude: 0.1, longitude: 1.0)
      course_lookup3 = create(:course_lookup, subject: 'english', delivery_type: 'Not known', latitude: 0.1, longitude: 1.0)
      search = described_class.new(
        postcode: 'NW6 8ET',
        topic: 'english'
      )

      expect(search.find_courses).to contain_exactly(
        course_lookup1, course_lookup2, course_lookup3
      )
    end

    it 'returns correct course lookups if all options selected' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )
      create(:course_lookup, subject: 'english', hours: 'Flexible', delivery_type: nil, latitude: 0.1, longitude: 2.0)
      course_lookup2 = create(:course_lookup, subject: 'english', hours: 'Flexible', delivery_type: 'Classroom based', latitude: 0.1, longitude: 1.0)
      create(:course_lookup, subject: 'english', hours: 'Not known', delivery_type: 'Not known', latitude: 0.1, longitude: 3.0)
      search = described_class.new(
        postcode: 'NW6 8ET',
        topic: 'english',
        options: {
          delivery_type: 'Classroom based',
          hours: 'Flexible',
          distance: 1
        }
      )

      expect(search.find_courses).to contain_exactly(
        course_lookup2
      )
    end
  end

  describe 'validation' do
    it 'is invalid if postcode entered is invalid' do
      search = described_class.new(postcode: 'NW6 8E', topic: nil)

      expect(search).not_to be_valid
    end

    it 'is invalid if postcode is not entered' do
      search = described_class.new(postcode: nil, topic: nil)

      expect(search).not_to be_valid
    end

    it 'is invalid if empty postcode entered' do
      search = described_class.new(postcode: '', topic: nil)

      expect(search).not_to be_valid
    end

    it 'is invalid if postcode is valid but does not exist' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [] }]
      )

      search = described_class.new(postcode: 'NW6 8ET')
      expect(search).not_to be_valid
    end

    it 'raises error if API for geocoding not available' do
      allow(Geocoder).to receive(:coordinates).and_raise(Geocoder::ServiceUnavailable)
      search = described_class.new(postcode: 'NW6 8ET', topic: nil)

      expect { search.find_courses }.to raise_error(described_class::GeocoderAPIError)
    end
  end
end
