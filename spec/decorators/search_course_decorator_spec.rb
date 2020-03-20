require 'rails_helper'

RSpec.describe SearchCourseDecorator do
  describe '#full_address' do
    it 'returns address' do
      search_course = SearchCourse.new(
        'venueAddress' => 'Queens Gardens Sites, HU1 3DG'
      )

      expect(described_class.new(search_course).full_address).to eq('Queens Gardens Sites, HU1 3DG')
    end

    it 'removes n/a values followed by comma' do
      search_course = SearchCourse.new(
        'venueAddress' => 'n/a, n/a, WA2 8QA'
      )

      expect(described_class.new(search_course).full_address).to eq('WA2 8QA')
    end

    it 'removes n/a values regardless of case' do
      search_course = SearchCourse.new(
        'venueAddress' => 'N/a, flat 1, N/A, Kingston Upon Hull, HU1 3DG'
      )

      expect(described_class.new(search_course).full_address).to eq('flat 1, Kingston Upon Hull, HU1 3DG')
    end

    it 'returns nothing if no address available' do
      search_course = SearchCourse.new(
        'venueAddress' => nil
      )

      expect(described_class.new(search_course).full_address).to be_nil
    end
  end
end
