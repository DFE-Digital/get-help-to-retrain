require 'rails_helper'

RSpec.describe FindAJobService do
  let(:service) {
    described_class.new(
      api_id: 'test',
      api_key: 'test'
    )
  }

  describe '#job_vacancy_count' do
    let(:find_a_job_developer_response) do
      {
        jobs: [],
        pager: {
          total_entries: 7180,
          current_page: 1,
          pages: 144
        }
      }.to_json
    end

    let(:find_a_job_zero_results_response) do
      {
        jobs: [],
        pager: {
          total_entries: 0,
          pages: 1,
          current_page: 1
        }
      }.to_json
    end

    it 'returns number of jobs for query, distance and postcode' do
      options = { name: 'developer', distance: 20, postcode: 'NW11' }
      stub_request(:get, /findajob/)
        .with(
          query: { 'api_id' => 'test', 'api_key' => 'test', 'q' => 'developer', 'd' => '20', 'w' => 'NW11' }
        )
        .to_return(body: find_a_job_developer_response)

      expect(service.job_vacancy_count(options)).to eq(7180)
    end

    it 'returns 0 number of jobs for query, distance and postcode if none present' do
      options = { name: 'developer', distance: 20, postcode: 'NW11' }
      stub_request(:get, /findajob/)
        .with(
          query: { 'api_id' => 'test', 'api_key' => 'test', 'q' => 'developer', 'd' => '20', 'w' => 'NW11' }
        )
        .to_return(body: find_a_job_zero_results_response)

      expect(service.job_vacancy_count(options)).to be_zero
    end

    it 'only uses outcode if full postcode supplied to query' do
      options = { name: 'developer', distance: 20, postcode: 'NW11 8QE' }
      request =
        stub_request(:get, /findajob/)
        .with(query: hash_including('w' => 'NW11'))
        .to_return(body: '{}')

      service.job_vacancy_count(options)

      expect(request).to have_been_requested
    end

    it 'ignores nil values when doing query' do
      options = { name: 'developer', distance: 20 }
      stub_request(:get, /findajob/)
        .with(
          query: { 'api_id' => 'test', 'api_key' => 'test', 'q' => 'developer', 'd' => '20' }
        )
        .to_return(body: find_a_job_developer_response)

      expect(service.job_vacancy_count(options)).to eq(7180)
    end

    it 'returns nothing if the api response is not successful' do
      options = { name: 'developer', distance: 20, postcode: 'NW11' }
      stub_request(:get, /findajob/)
        .to_return(status: 500)

      expect(service.job_vacancy_count(options)).to be_nil
    end

    it 'returns nothing if the query is not authorised' do
      options = { name: 'developer', distance: 20, postcode: 'NW11' }
      service = described_class.new(
        api_id: 'wrong-id',
        api_key: 'wrong-id'
      )

      stub_request(:get, /findajob/)
        .to_return(status: 401)

      expect(service.job_vacancy_count(options)).to be_nil
    end

    it 'does not perform query if there is no api key' do
      options = { name: 'developer', distance: 20, postcode: 'NW11' }
      service = described_class.new(
        api_id: 'test',
        api_key: nil
      )

      service.job_vacancy_count(options)
      expect(a_request(:get, /findajob/)).not_to have_been_made
    end

    it 'does not perform query if there is no api id' do
      options = { name: 'developer', distance: 20, postcode: 'NW11' }
      service = described_class.new(
        api_id: nil,
        api_key: 'test'
      )

      service.job_vacancy_count(options)
      expect(a_request(:get, /findajob/)).not_to have_been_made
    end

    it 'returns nothing if there is no api key' do
      options = { name: 'developer', distance: 20, postcode: 'NW11' }
      service = described_class.new(
        api_id: 'test',
        api_key: nil
      )

      expect(service.job_vacancy_count(options)).to be_nil
    end

    it 'returns nothing if there is no api id' do
      options = { name: 'developer', distance: 20, postcode: 'NW11' }
      service = described_class.new(
        api_id: nil,
        api_key: 'test'
      )

      expect(service.job_vacancy_count(options)).to be_nil
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

      expect { service.health_check }.to raise_exception(described_class::ResponseError)
    end

    it 'raises error if the query is not authorised' do
      stub_request(:get, /findajob/)
        .to_return(status: 401)

      expect { service.health_check }.to raise_exception(described_class::ResponseError)
    end
  end
end
