require 'rails_helper'

RSpec.describe FindACourseService do
  let(:service) {
    described_class.new(
      api_key: 'test',
      api_base_url: 'https://pp.api.nationalcareers.service.gov.uk/coursedirectory/findacourse/'
    )
  }

  describe '#search' do
    xit 'Must do something'
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
