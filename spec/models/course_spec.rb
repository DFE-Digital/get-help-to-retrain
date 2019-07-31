require 'rails_helper'

RSpec.describe Course, type: :model do
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
        'NW6 8ET', [{ 'coordinates' => [] }]
      )

      course = create(:course, postcode: 'nw68et')
      expect(course.attributes).to include(
        'latitude' => 0.0,
        'longitude' => 0.0
      )
    end
  end
end
