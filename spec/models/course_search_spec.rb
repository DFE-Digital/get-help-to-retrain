require 'rails_helper'

RSpec.describe CourseSearch do
  let(:find_a_course_search_response) do
    JSON.parse(
      Rails.root.join('spec', 'fixtures', 'files', 'find_a_course_search_response.json').read
    )
  end

  describe '#search' do
    it 'returns nothing if no postcode entered' do
      search = described_class.new(postcode: nil, topic: 'maths')
      expect(search.search).to be_empty
    end

    it 'returns nothing if empty postcode entered' do
      search = described_class.new(postcode: '', topic: 'english')
      expect(search.search).to be_empty
    end

    it 'returns nothing if no topic entered' do
      search = described_class.new(postcode: 'NW6 8ET', topic: nil)
      expect(search.search).to be_empty
    end

    it 'returns search course instances for find a course api results' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )

      find_a_course_service = instance_double(
        FindACourseService,
        search: find_a_course_search_response
      )
      allow(FindACourseService).to receive(:new).and_return(find_a_course_service)
      search = described_class.new(postcode: 'NW6 8ET', topic: 'maths')

      expect(search.search.first).to be_a_kind_of(SearchCourse)
    end

    it 'defaults to empty results if no results found' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )

      find_a_course_service = instance_double(
        FindACourseService,
        search: {}
      )
      allow(FindACourseService).to receive(:new).and_return(find_a_course_service)

      search = described_class.new(postcode: 'NW6 8ET', topic: 'maths')

      expect(search.search).to be_empty
    end

    it 'returns correct number of results if search successful' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )

      find_a_course_service = instance_double(
        FindACourseService,
        search: find_a_course_search_response
      )
      allow(FindACourseService).to receive(:new).and_return(find_a_course_service)

      search = described_class.new(postcode: 'NW6 8ET', topic: 'maths')

      expect(search.search.count).to eq(3)
    end

    it 'returns search courses and preserves order by distance to postcode entered' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )

      find_a_course_service = instance_double(
        FindACourseService,
        search: find_a_course_search_response
      )
      allow(FindACourseService).to receive(:new).and_return(find_a_course_service)

      search = described_class.new(postcode: 'NW6 8ET', topic: 'maths')

      expect(search.search.map(&:distance)).to eq(
        [3.32, 3.5, 3.81]
      )
    end

    it 'defaults to qualification, distance, and no hours and delivery values if no options entered' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )
      find_a_course_service = instance_spy(
        FindACourseService, search: {}
      )
      allow(FindACourseService).to receive(:new).and_return(find_a_course_service)

      course_search = described_class.new(
        postcode: 'NW6 8ET',
        topic: 'maths'
      )

      course_search.search
      expect(find_a_course_service).to have_received(:search).with(
        options: {
          keyword: 'maths',
          distance: '20',
          qualification_levels: %w[1 2 X E],
          postcode: 'NW6 8ET',
          sort_by: 4,
          start: 0,
          limit: 10
        }
      )
    end

    it 'sets distance, hours and delivery values if options entered' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )
      find_a_course_service = instance_spy(
        FindACourseService, search: {}
      )
      allow(FindACourseService).to receive(:new).and_return(find_a_course_service)

      course_search = described_class.new(
        postcode: 'NW6 8ET',
        topic: 'english',
        options: {
          distance: '40',
          hours: '1',
          delivery_type: '2'
        }
      )

      course_search.search
      expect(find_a_course_service).to have_received(:search).with(
        options: {
          keyword: 'english',
          distance: '40',
          qualification_levels: %w[1 2 X E],
          postcode: 'NW6 8ET',
          sort_by: 4,
          start: 0,
          limit: 10,
          study_modes: ['1'],
          delivery_modes: ['2']
        }
      )
    end

    it 'ignores 0 values for hours and delivery types' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )
      find_a_course_service = instance_spy(
        FindACourseService, search: {}
      )
      allow(FindACourseService).to receive(:new).and_return(find_a_course_service)

      course_search = described_class.new(
        postcode: 'NW6 8ET',
        topic: 'english',
        options: {
          hours: 'All',
          delivery_type: 'All'
        }
      )

      course_search.search
      expect(find_a_course_service).to have_received(:search).with(
        options: {
          keyword: 'english',
          distance: '20',
          qualification_levels: %w[1 2 X E],
          postcode: 'NW6 8ET',
          sort_by: 4,
          start: 0,
          limit: 10
        }
      )
    end

    it 'offsets index of results to page number' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )
      find_a_course_service = instance_spy(
        FindACourseService, search: {}
      )
      allow(FindACourseService).to receive(:new).and_return(find_a_course_service)

      course_search = described_class.new(
        postcode: 'NW6 8ET',
        topic: 'english',
        options: {
          page: '5'
        }
      )

      course_search.search
      expect(find_a_course_service).to have_received(:search).with(
        options: {
          keyword: 'english',
          distance: '20',
          qualification_levels: %w[1 2 X E],
          postcode: 'NW6 8ET',
          sort_by: 4,
          start: 40,
          limit: 10
        }
      )
    end

    it 'detauls to 0 index if its first page entered in options' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )

      find_a_course_service = instance_spy(
        FindACourseService, search: {}
      )
      allow(FindACourseService).to receive(:new).and_return(find_a_course_service)

      course_search = described_class.new(
        postcode: 'NW6 8ET',
        topic: 'english',
        options: {
          page: '1'
        }
      )

      course_search.search
      expect(find_a_course_service).to have_received(:search).with(
        options: {
          keyword: 'english',
          distance: '20',
          qualification_levels: %w[1 2 X E],
          postcode: 'NW6 8ET',
          sort_by: 4,
          start: 0,
          limit: 10
        }
      )
    end
  end

  describe '#count' do
    it 'returns the count from the course search result' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )

      find_a_course_service = instance_double(
        FindACourseService,
        search: find_a_course_search_response
      )
      allow(FindACourseService).to receive(:new).and_return(find_a_course_service)

      search = described_class.new(postcode: 'NW6 8ET', topic: 'maths')

      expect(search.count).to eq(166)
    end

    it 'defaults to 0 if no result found' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )

      find_a_course_service = instance_double(
        FindACourseService,
        search: {}
      )
      allow(FindACourseService).to receive(:new).and_return(find_a_course_service)

      search = described_class.new(postcode: 'NW6 8ET', topic: 'maths')

      expect(search.count).to be_zero
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

      search = described_class.new(postcode: 'NW6 8ET', topic: 'english')
      expect(search).not_to be_valid
    end

    it 'raises error if API for geocoding not available' do
      allow(Geocoder).to receive(:coordinates).and_raise(Geocoder::ServiceUnavailable)
      search = described_class.new(postcode: 'NW6 8ET', topic: nil)

      expect { search.search }.to raise_error(described_class::GeocoderAPIError)
    end

    it 'is invalid if topic is not entered' do
      Geocoder::Lookup::Test.add_stub(
        'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
      )
      search = described_class.new(postcode: 'NW6 8ET', topic: nil)

      expect(search).not_to be_valid
    end
  end
end
