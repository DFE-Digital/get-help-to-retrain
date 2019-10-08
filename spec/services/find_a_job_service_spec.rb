require 'rails_helper'

RSpec.describe FindAJobService do
  describe '#job_vacancies_number' do
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
      service = described_class.new(
        api_id: 'test',
        api_key: 'test',
        options: { query: 'developer', distance: 20, postcode: 'NW11' }
      )

      stub_request(:get, /findajob/)
        .with(
          query: { 'api_id' => 'test', 'api_key' => 'test', 'q' => 'developer', 'd' => '20', 'w' => 'NW11' }
        )
        .to_return(body: find_a_job_developer_response)

      expect(service.job_vacancies).to eq(7180)
    end

    it 'returns 0 number of jobs for query, distance and postcode if none present' do
      service = described_class.new(
        api_id: 'test',
        api_key: 'test',
        options: { query: 'developer', distance: 20, postcode: 'NW11' }
      )

      stub_request(:get, /findajob/)
        .with(
          query: { 'api_id' => 'test', 'api_key' => 'test', 'q' => 'developer', 'd' => '20', 'w' => 'NW11' }
        )
        .to_return(body: find_a_job_zero_results_response)

      expect(service.job_vacancies).to be_zero
    end

    it 'only uses outcode if full postcode supplied to query' do
      service = described_class.new(
        api_id: 'test',
        api_key: 'test',
        options: { query: 'developer', postcode: 'NW11 8QE', distance: 20 }
      )

      request =
        stub_request(:get, /findajob/)
        .with(query: hash_including('w' => 'NW11'))
        .to_return(body: '{}')

      service.job_vacancies

      expect(request).to have_been_requested
    end

    it 'ignores nil postcodes when doing query' do
      service = described_class.new(
        api_id: 'test',
        api_key: 'test',
        options: { query: 'developer', distance: 20 }
      )

      stub_request(:get, /findajob/)
        .with(
          query: { 'api_id' => 'test', 'api_key' => 'test', 'q' => 'developer', 'd' => '20' }
        )
        .to_return(body: find_a_job_developer_response)

      expect(service.job_vacancies).to eq(7180)
    end

    it 'returns nothing if the api response is not successful' do
      service = described_class.new(
        api_id: 'test',
        api_key: 'test',
        options: { query: 'developer', postcode: 'NW11 8QE', distance: 20 }
      )

      stub_request(:get, /findajob/)
        .to_return(status: 500)

      expect(service.job_vacancies).to be_nil
    end

    it 'returns nothing if the query is not authorised' do
      service = described_class.new(
        api_id: 'wrong-id',
        api_key: 'wrong-id',
        options: { query: 'developer', postcode: 'NW11 8QE', distance: 20 }
      )

      stub_request(:get, /findajob/)
        .to_return(status: 401)

      expect(service.job_vacancies).to be_nil
    end

    it 'does not perform query if there is no api key' do
      service = described_class.new(
        api_id: 'test',
        api_key: nil,
        options: { query: 'developer', postcode: 'NW11 8QE', distance: 20 }
      )

      service.job_vacancies
      expect(a_request(:get, /findajob/)).not_to have_been_made
    end

    it 'does not perform query if there is no api id' do
      service = described_class.new(
        api_id: nil,
        api_key: 'test',
        options: { query: 'developer', postcode: 'NW11 8QE', distance: 20 }
      )

      service.job_vacancies
      expect(a_request(:get, /findajob/)).not_to have_been_made
    end

    it 'returns nothing if there is no api key' do
      service = described_class.new(
        api_id: 'test',
        api_key: nil,
        options: { query: 'developer', postcode: 'NW11 8QE', distance: 20 }
      )

      service.job_vacancies
      expect(service.job_vacancies).to be_nil
    end

    it 'returns nothing if there is no api id' do
      service = described_class.new(
        api_id: nil,
        api_key: 'test',
        options: { query: 'developer', postcode: 'NW11 8QE', distance: 20 }
      )

      service.job_vacancies
      expect(service.job_vacancies).to be_nil
    end
  end
end
