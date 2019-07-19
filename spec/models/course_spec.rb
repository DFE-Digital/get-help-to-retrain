require 'rails_helper'

RSpec.describe Course, type: :model do
  describe '.find_courses_near' do
    it 'returns nothing if no postcode entered' do
      expect(described_class.find_courses_near(search_postcode: nil)).to be_empty
    end

    it 'returns nothing if empty postcode entered' do
      expect(described_class.find_courses_near(search_postcode: '')).to be_empty
    end

    it 'returns courses ordered by distance to postcode entered' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )

      course1 = create(:course, latitude: 0.1, longitude: 1.001)
      course2 = create(:course, latitude: 0.1, longitude: 1.003)
      course3 = create(:course, latitude: 0.1, longitude: 1.002)

      expect(described_class.find_courses_near(search_postcode: 'NW6 8ET', distance: 2)).to eq(
        [course1, course3, course2]
      )
    end

    it 'scopes courses by topic' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )

      create(:course, latitude: 0.1, longitude: 1, topic: 'maths')
      course2 = create(:course, latitude: 0.1, longitude: 1, topic: 'english')
      create(:course, latitude: 0.1, longitude: 1, topic: 'maths')

      expect(described_class.find_courses_near(search_postcode: 'NW6 8ET', distance: 2, topic: 'english')).to contain_exactly(
        course2
      )
    end

    it 'limist courses to distance entered from postcode' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )

      course1 = create(:course, latitude: 0.1, longitude: 1.001)
      create(:course, latitude: 0.1, longitude: 1.2)
      create(:course, latitude: 0.1, longitude: 1.3)

      expect(described_class.find_courses_near(search_postcode: 'NW6 8ET', distance: 1)).to eq(
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

      expect(described_class.find_courses_near(search_postcode: 'NW6 8ET', distance: 10)).to be_empty
    end

    it 'raises error if postcode entered if invalid' do
      expect { described_class.find_courses_near(search_postcode: 'NW6 ET') }.to raise_error(described_class::InvalidPostcodeError)
    end

    it 'raises error if API for geocoding not available' do
      allow(Geocoder).to receive(:coordinates).and_raise(Geocoder::ServiceUnavailable)

      expect { described_class.find_courses_near(search_postcode: 'NW6 8ET') }.to raise_error(described_class::GeocoderAPIError)
    end
  end

  describe '#format_postcode' do
    it 'formats postcode on creation' do
      course = create(:course, postcode: 'nw6  8et')
      expect(course.postcode).to eq('NW6 8ET')
    end

    it 'formats postcode on update' do
      course = create(:course, postcode: 'NW6 9ET')
      course.update_attributes(postcode: ' ne10PT ')
      expect(course.postcode).to eq('NE1 0PT')
    end
  end

  context 'with validations' do
    it 'is not valid if email format is incorrect' do
      course = build(:course, email: 'weirdemail@')
      expect(course).not_to be_valid
    end

    it 'is not valid if postcode is incorrect' do
      course = build(:course, postcode: 'NW9 9l')
      expect(course).not_to be_valid
    end

    it 'is not valid if postcode is not full' do
      course = build(:course, postcode: 'NW9')
      expect(course).not_to be_valid
    end

    it 'is not valid if postcode is not present' do
      course = build(:course, postcode: nil)
      expect(course).not_to be_valid
    end

    it 'is not valid if postcode is empty' do
      course = build(:course, postcode: '')
      expect(course).not_to be_valid
    end
  end

  context 'when geocoding' do
    it 'adds latitude and longitude values when empty' do
      course = create(:course, postcode: 'sw1p3bt')
      expect(course.attributes).to include(
        'latitude' => 40.7143528,
        'longitude' => -74.0059731
      )
    end

    it 'does not change lat/long values when they exist' do
      course = create(:course, postcode: 'sw1p3bt', latitude: 51.498029, longitude: -0.130039)
      expect(course.attributes).to include(
        'latitude' => 51.498029,
        'longitude' => -0.130039
      )
    end

    it 'does not change lat/long values when course data is updated' do
      course = create(:course, postcode: 'sw1p3bt', latitude: 51.498029, longitude: -0.130039)
      course.update_attributes(title: 'New Course title')

      expect(course.attributes).to include(
        'latitude' => 51.498029,
        'longitude' => -0.130039
      )
    end

    it 'changes lat/long values when postcode is updated' do
      course = create(:course, postcode: 'sw1p3bt', latitude: 51.498029, longitude: -0.130039)
      course.update_attributes(postcode: 'sw1p3bs')

      expect(course.attributes).to include(
        'latitude' => 40.7143528,
        'longitude' => -74.0059731
      )
    end

    it 'does not set lat/long if postcode does not exist' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [nil, nil] }]
      )

      course = create(:course, postcode: 'nw68et')
      expect(course.attributes).to include(
        'latitude' => 0.0,
        'longitude' => 0.0
      )
    end
  end
end
