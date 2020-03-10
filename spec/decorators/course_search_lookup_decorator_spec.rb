require 'rails_helper'

RSpec.describe CourseSearchLookupDecorator do
  describe '#full_address' do
    it 'returns address if no commas included' do
      search_course = SearchCourse.new(
        'venueAddress' => 'Queens Gardens Sites HU1 3DG'
      )

      expect(described_class.new(search_course).full_address).to eq('Queens Gardens Sites HU1 3DG')
    end

    it 'adds line break to one comma' do
      search_course = SearchCourse.new(
        'venueAddress' => 'Kingston Upon Hull, HU1 3DG'
      )

      expect(described_class.new(search_course).full_address).to eq('Kingston Upon Hull<br/> HU1 3DG')
    end

    it 'adds line breaks to multiple commas' do
      search_course = SearchCourse.new(
        'venueAddress' => 'Queens Gardens Sites, Kingston Upon Hull, HU1 3DG'
      )

      expect(described_class.new(search_course).full_address).to eq(
        'Queens Gardens Sites<br/> Kingston Upon Hull<br/> HU1 3DG'
      )
    end

    it 'only adds line breaks to last two commas if more available' do
      search_course = SearchCourse.new(
        'venueAddress' => 'Building no 5, 83a avenue, Queens Gardens Sites, Kingston Upon Hull, HU1 3DG'
      )

      expect(described_class.new(search_course).full_address).to eq(
        'Building no 5, 83a avenue, Queens Gardens Sites<br/> Kingston Upon Hull<br/> HU1 3DG'
      )
    end

    it 'returns nothing if no address available' do
      search_course = SearchCourse.new(
        'venueAddress' => nil
      )

      expect(described_class.new(search_course).full_address).to be_nil
    end
  end
end
