require 'rails_helper'

RSpec.describe FindACourseService do
  let(:service) {
    described_class.new(
      api_key: 'test',
      api_base_url: 'https://pp.api.nationalcareers.service.gov.uk/coursedirectory/findacourse/'
    )
  }

  describe '#search' do
    let(:find_a_course_search_response) do
      Rails.root.join('spec', 'fixtures', 'files', 'find_a_course_search_response.json').read
    end

    let(:find_a_course_empty_search_response) do
      {
        'facets' => {
          'Region' => [],
          'ProviderName' => [],
          'AttendancePattern' => [],
          'StudyMode' => [],
          'DeliveryMode' => [],
          'QualificationLevel' => []
        },
        'results' => [],
        'total' => 0,
        'limit' => 1,
        'start' => 20
      }
    end

    it 'does not perform query if there is no api key' do
      service = described_class.new(
        api_base_url: 'test',
        api_key: nil
      )

      service.search
      expect(a_request(:post, /findacourse/)).not_to have_been_made
    end

    it 'does not perform query if there is no api base url' do
      service = described_class.new(
        api_base_url: nil,
        api_key: 'test'
      )

      service.search
      expect(a_request(:post, /findacourse/)).not_to have_been_made
    end

    it 'returns nothing if there is no api key' do
      service = described_class.new(
        api_base_url: 'test',
        api_key: nil
      )

      expect(service.search).to be_empty
    end

    it 'returns nothing if there is no api base url' do
      service = described_class.new(
        api_base_url: nil,
        api_key: 'test'
      )

      expect(service.search).to be_empty
    end

    it 'raises error if the api response is not successful' do
      options = { keyword: 'maths' }
      stub_request(:post, /findacourse/)
        .to_return(status: 500)

      expect { service.search(options: options) }.to raise_exception(described_class::APIError)
    end

    it 'raises error if the query is not authorised' do
      options = { keyword: 'maths' }
      service = described_class.new(
        api_base_url: 'https://findacourse.com',
        api_key: 'wrong-key'
      )

      stub_request(:post, /findacourse/)
        .to_return(status: 403)

      expect { service.search(options: options) }.to raise_exception(described_class::APIError)
    end

    it 'raises error if there is a NET::HTTP error' do
      options = { keyword: 'maths' }
      stub_request(:post, /findacourse/)
        .to_raise(Net::ReadTimeout)

      expect { service.search(options: options) }.to raise_exception(described_class::APIError)
    end

    it 'returns response for all options' do
      options = {
        keyword: 'maths',
        distance: 20.0,
        qualification_levels: %w[1 2 X E],
        study_modes: [2, 3],
        delivery_modes: [1, 2],
        postcode: 'nw11 8qe',
        sort_by: 4,
        limit: 1,
        start: 20
      }

      stub_request(:post, /findacourse/)
        .with(
          body: {
            'subjectKeyword' => 'maths',
            'distance' => 20.0,
            'qualificationLevels' => %w[1 2 X E],
            'studyModes' => [2, 3],
            'deliveryModes' => [1, 2],
            'postcode' => 'nw11 8qe',
            'sortBy' => 4,
            'limit' => 1,
            'start' => 20
          }.to_json
        )
        .to_return(body: find_a_course_search_response)

      expect(service.search(options: options)).to eq(
        JSON.parse(find_a_course_search_response)
      )
    end

    it 'returns 0 courses if none present' do
      options = {
        keyword: 'physics',
        distance: 0.0,
        qualification_levels: ['1'],
        study_modes: [2],
        delivery_modes: [1],
        postcode: 'nw11 8qe',
        sort_by: 4,
        limit: 1,
        start: 20
      }

      stub_request(:post, /findacourse/)
        .with(
          body: {
            'subjectKeyword' => 'physics',
            'distance' => 0.0,
            'qualificationLevels' => ['1'],
            'studyModes' => [2],
            'deliveryModes' => [1],
            'postcode' => 'nw11 8qe',
            'sortBy' => 4,
            'limit' => 1,
            'start' => 20
          }.to_json
        )
        .to_return(body: find_a_course_empty_search_response.to_json)

      expect(service.search(options: options)).to eq(
        find_a_course_empty_search_response
      )
    end

    it 'ignores nil values when doing query' do
      options = { keyword: 'maths', sort_by: 1 }
      stub_request(:post, /findacourse/)
        .with(
          body: {
            'subjectKeyword' => 'maths',
            'sortBy' => 1
          }.to_json
        )
        .to_return(body: find_a_course_empty_search_response.to_json)

      expect(service.search(options: options)).to eq(find_a_course_empty_search_response)
    end
  end

  describe '#details' do
    let(:api_endpoint) {
      'https://pp.api.nationalcareers.service.gov.uk/coursedirectory/findacourse/courserundetail'
    }

    let(:request_headers) {
      {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Ocp-Apim-Subscription-Key' => 'test'
      }
    }

    let(:response_body) {
      {
        provider: {
          providerName: 'OUTSOURCE VOCATIONAL LEARNING LIMITED'
        },
        course: {
          advancedLearnerLoan: true,
          awardOrgCode: 'EDEXCEL'
        }
      }.with_indifferent_access
    }

    context 'when the api key is missing' do
      let(:service) {
        described_class.new(
          api_key: nil,
          api_base_url: 'https://valid-url.com'
        )
      }

      it 'returns {}' do
        expect(service.details(course_id: '111-1', course_run_id: '222-2')).to be_empty
      end
    end

    context 'when the api base url is missing' do
      let(:service) {
        described_class.new(
          api_key: 'test',
          api_base_url: nil
        )
      }

      it 'returns {}' do
        expect(service.details(course_id: '111-1', course_run_id: '222-2')).to be_empty
      end
    end

    context 'when the course_id is missing' do
      let(:service) {
        described_class.new(
          api_key: 'test',
          api_base_url: 'some-valid-url'
        )
      }

      it 'returns {}' do
        expect(
          service.details(course_id: nil, course_run_id: '222-2')
        ).to be_empty
      end
    end

    context 'when the course_run_id is missing' do
      let(:service) {
        described_class.new(
          api_key: 'test',
          api_base_url: 'test'
        )
      }

      it 'returns {}' do
        expect(
          service.details(course_id: '111-11', course_run_id: nil)
        ).to be_empty
      end
    end

    context 'when valid arguments are passed it' do
      before do
        stub_request(:get, api_endpoint)
          .with(headers: request_headers,
                query: URI.encode_www_form(CourseId: '111-11', CourseRunId: '222-2'))
          .to_return(body: response_body.to_json, status: 200)
      end

      it 'returns the course details' do
        expect(
          service.details(course_id: '111-11', course_run_id: '222-2')
        ).to eq(response_body)
      end
    end

    context 'when the api key is wrong' do
      let(:service) {
        described_class.new(
          api_key: 'wrong-key',
          api_base_url: 'https://pp.api.nationalcareers.service.gov.uk/coursedirectory/findacourse/'
        )
      }

      let(:request_headers) {
        {
          'Content-Type' => 'application/x-www-form-urlencoded',
          'Ocp-Apim-Subscription-Key' => 'wrong-key'
        }
      }

      it 'raises the error' do
        stub_request(:get, api_endpoint)
          .with(headers: request_headers,
                query: URI.encode_www_form(CourseId: '111-11', CourseRunId: '222-2'))
          .to_return(status: 401)

        expect {
          service.details(course_id: '111-11', course_run_id: '222-2')
        }.to raise_exception(described_class::APIError)
      end
    end

    context 'when there is an NCS service internal error' do
      it 'raises the error' do
        stub_request(:get, api_endpoint)
          .with(headers: request_headers,
                query: URI.encode_www_form(CourseId: '111-11', CourseRunId: '222-2'))
          .to_return(status: 500)

        expect {
          service.details(course_id: '111-11', course_run_id: '222-2')
        }.to raise_exception(described_class::APIError)
      end
    end

    context 'when forbidden from accessing a resource' do
      it 'raises the error' do
        stub_request(:get, api_endpoint)
          .with(headers: request_headers,
                query: URI.encode_www_form(CourseId: '111-11', CourseRunId: '222-2'))
          .to_return(status: 403)

        expect {
          service.details(course_id: '111-11', course_run_id: '222-2')
        }.to raise_exception(described_class::APIError)
      end
    end

    context 'when there is a NET::HTTP error' do
      it 'raises the error' do
        stub_request(:get, api_endpoint)
          .to_raise(Net::ReadTimeout)

        expect {
          service.details(course_id: '111-11', course_run_id: '222-2')
        }.to raise_exception(described_class::APIError)
      end
    end
  end
end
