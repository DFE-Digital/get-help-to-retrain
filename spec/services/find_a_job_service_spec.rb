require 'rails_helper'

RSpec.describe FindAJobService do
  let(:service) {
    described_class.new(
      api_id: 'test',
      api_key: 'test'
    )
  }

  describe '#job_vacancies' do
    let(:find_a_job_developer_response) do
      {
        'jobs' => [
          {
            'url' => 'https://findajob.dwp.gov.uk/details/111',
            'location' => 'London',
            'company' => 'Some company',
            'salary' => '£9.00 per hour',
            'posted' => '2019-09-27T13:27:27',
            'title' => 'Admin Assistant'
          }
        ],
        'pager' => {
          'total_entries' => 7180,
          'current_page' => 1,
          'pages' => 144
        }
      }
    end

    let(:find_a_job_zero_results_response) do
      {
        'jobs' => [],
        'pager' => {
          'total_entries' => 0,
          'pages' => 1,
          'current_page' => 1
        }
      }
    end

    it 'returns response for query, distance and postcode' do
      options = { name: 'developer', distance: 20, postcode: 'NW11' }
      stub_request(:get, /findajob/)
        .with(
          query: { 'api_id' => 'test', 'api_key' => 'test', 'q' => 'developer', 'd' => '20', 'w' => 'NW11' }
        )
        .to_return(body: find_a_job_developer_response.to_json)

      expect(service.job_vacancies(options)).to eq(find_a_job_developer_response)
    end

    it 'returns 0 jobs for query, distance and postcode if none present' do
      options = { name: 'developer', distance: 20, postcode: 'NW11' }
      stub_request(:get, /findajob/)
        .with(
          query: { 'api_id' => 'test', 'api_key' => 'test', 'q' => 'developer', 'd' => '20', 'w' => 'NW11' }
        )
        .to_return(body: find_a_job_zero_results_response.to_json)

      expect(service.job_vacancies(options)).to eq(find_a_job_zero_results_response)
    end

    it 'only uses outcode if full postcode supplied to query' do
      options = { name: 'developer', distance: 20, postcode: 'NW11 8QE' }
      request =
        stub_request(:get, /findajob/)
        .with(query: hash_including('w' => 'NW11'))
        .to_return(body: '{}')

      service.job_vacancies(options)

      expect(request).to have_been_requested
    end

    it 'ignores nil values when doing query' do
      options = { name: 'developer', distance: 20 }
      stub_request(:get, /findajob/)
        .with(
          query: { 'api_id' => 'test', 'api_key' => 'test', 'q' => 'developer', 'd' => '20' }
        )
        .to_return(body: find_a_job_developer_response.to_json)

      expect(service.job_vacancies(options)).to eq(find_a_job_developer_response)
    end

    it 'raises error if the api response is not successful' do
      options = { name: 'developer', distance: 20, postcode: 'NW11' }
      stub_request(:get, /findajob/)
        .to_return(status: 500)

      expect { service.job_vacancies(options) }.to raise_exception(described_class::APIError)
    end

    it 'raises error if the query is not authorised' do
      options = { name: 'developer', distance: 20, postcode: 'NW11' }
      service = described_class.new(
        api_id: 'wrong-id',
        api_key: 'wrong-id'
      )

      stub_request(:get, /findajob/)
        .to_return(status: 401)

      expect { service.job_vacancies(options) }.to raise_exception(described_class::APIError)
    end

    it 'raises error if there is a NET::HTTP error' do
      options = { name: 'developer', distance: 20, postcode: 'NW11' }
      stub_request(:get, /findajob/)
        .to_raise(Net::ReadTimeout)

      expect { service.job_vacancies(options) }.to raise_exception(described_class::APIError)
    end

    it 'does not perform query if there is no api key' do
      options = { name: 'developer', distance: 20, postcode: 'NW11' }
      service = described_class.new(
        api_id: 'test',
        api_key: nil
      )

      service.job_vacancies(options)
      expect(a_request(:get, /findajob/)).not_to have_been_made
    end

    it 'does not perform query if there is no api id' do
      options = { name: 'developer', distance: 20, postcode: 'NW11' }
      service = described_class.new(
        api_id: nil,
        api_key: 'test'
      )

      service.job_vacancies(options)
      expect(a_request(:get, /findajob/)).not_to have_been_made
    end

    it 'returns nothing if there is no api key' do
      options = { name: 'developer', distance: 20, postcode: 'NW11' }
      service = described_class.new(
        api_id: 'test',
        api_key: nil
      )

      expect(service.job_vacancies(options)).to be_empty
    end

    it 'returns nothing if there is no api id' do
      options = { name: 'developer', distance: 20, postcode: 'NW11' }
      service = described_class.new(
        api_id: nil,
        api_key: 'test'
      )

      expect(service.job_vacancies(options)).to be_empty
    end
  end

  describe '#health_check' do
    let(:ping_response) do
      { 'ping' => 'ok' }
    end

    it 'returns ping response in JSON' do
      stub_request(:get, /findajob/)
        .with(query: { 'api_id' => 'test', 'api_key' => 'test' })
        .to_return(body: ping_response.to_json)

      expect(service.health_check).to eq(ping_response)
    end

    it 'raises error if the api response is not successful' do
      stub_request(:get, /findajob/)
        .to_return(status: 500)

      expect { service.health_check }.to raise_exception(described_class::APIError)
    end

    it 'raises error if the query is not authorised' do
      stub_request(:get, /findajob/)
        .to_return(status: 401)

      expect { service.health_check }.to raise_exception(described_class::APIError)
    end

    it 'raises error if there is a NET::HTTP error' do
      stub_request(:get, /ping/)
        .to_raise(Net::ReadTimeout)

      expect { service.health_check }.to raise_exception(described_class::APIError)
    end
  end
end
