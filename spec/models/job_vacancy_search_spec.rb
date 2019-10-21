require 'rails_helper'

RSpec.describe JobVacancySearch do
  let(:find_a_job_developer_response) do
    {
      'jobs' => [
        {
          'url' => 'https://findajob.dwp.gov.uk/details/111',
          'title' => 'Admin Assistant'
        }
      ],
      'pager' => {
        'total_entries' => 1
      }
    }
  end

  let(:find_a_job_zero_results_response) do
    {
      'jobs' => [],
      'pager' => {
        'total_entries' => 0
      }
    }
  end

  describe '#jobs' do
    it 'returns job vacancies for find a job api jobs' do
      search = described_class.new(postcode: 'NW6 8QE', name: 'Admin')
      find_a_job_service = instance_double(FindAJobService, job_vacancies: find_a_job_developer_response)
      allow(FindAJobService).to receive(:new).and_return(find_a_job_service)

      expect(search.jobs.first).to be_a_kind_of(JobVacancy)
    end

    it 'returns an empty array if 0 jobs available' do
      search = described_class.new(postcode: 'NW6 8QE', name: 'Admin')
      find_a_job_service = instance_double(FindAJobService, job_vacancies: find_a_job_zero_results_response)
      allow(FindAJobService).to receive(:new).and_return(find_a_job_service)

      expect(search.jobs).to be_empty
    end

    it 'returns an empty array if search not valid' do
      search = described_class.new(postcode: 'NW6', name: 'Admin')

      expect(search.jobs).to be_empty
    end

    it 'returns an empty array if there is an API exception' do
      search = described_class.new(postcode: 'NW6 8QE', name: 'Admin')
      find_a_job_service = instance_double(FindAJobService, job_vacancies: {})
      allow(FindAJobService).to receive(:new).and_return(find_a_job_service)

      expect(search.jobs).to be_empty
    end
  end

  describe '#count' do
    it 'returns the count from API response' do
      search = described_class.new(postcode: 'NW6 8QE', name: 'Admin')
      find_a_job_service = instance_double(FindAJobService, job_vacancies: find_a_job_developer_response)
      allow(FindAJobService).to receive(:new).and_return(find_a_job_service)

      expect(search.count).to eq(1)
    end

    it 'returns 0 if there are no jobs from the API response' do
      search = described_class.new(postcode: 'NW6 8QE', name: 'Admin')
      find_a_job_service = instance_double(FindAJobService, job_vacancies: find_a_job_zero_results_response)
      allow(FindAJobService).to receive(:new).and_return(find_a_job_service)

      expect(search.count).to be_zero
    end

    it 'returns nil if search not valid' do
      search = described_class.new(postcode: 'NW6', name: 'Admin')

      expect(search.count).to be_nil
    end

    it 'returns nil if there is an API exception' do
      search = described_class.new(postcode: 'NW6 8QE', name: 'Admin')
      find_a_job_service = instance_double(FindAJobService, job_vacancies: {})
      allow(FindAJobService).to receive(:new).and_return(find_a_job_service)

      expect(search.count).to be_nil
    end
  end

  describe '#page_relative_to_api' do
    it 'defaults to page 1 if no page given' do
      search = described_class.new(postcode: 'NW9 8TE', name: nil)

      expect(search.page_relative_to_api).to eq(1)
    end

    it 'returns page 1 if nil page given' do
      search = described_class.new(postcode: 'NW9 8TE', name: nil, page: nil)

      expect(search.page_relative_to_api).to eq(1)
    end

    it 'returns page relative to 50 pages from api if less than 50' do
      search = described_class.new(postcode: 'NW9 8TE', name: nil, page: '4')

      expect(search.page_relative_to_api).to eq(1)
    end

    it 'returns page relative to 50 pages from api if equal than 50' do
      search = described_class.new(postcode: 'NW9 8TE', name: nil, page: '5')

      expect(search.page_relative_to_api).to eq(1)
    end

    it 'returns page relative to 50 pages from api if over than 50' do
      search = described_class.new(postcode: 'NW9 8TE', name: nil, page: '9')

      expect(search.page_relative_to_api).to eq(2)
    end
  end

  describe 'validation' do
    it 'is invalid if postcode entered is invalid' do
      search = described_class.new(postcode: 'NW6 8E', name: nil)

      expect(search).not_to be_valid
    end

    it 'is invalid if postcode is not entered' do
      search = described_class.new(postcode: nil, name: nil)

      expect(search).not_to be_valid
    end

    it 'is invalid if empty postcode entered' do
      search = described_class.new(postcode: '', name: nil)

      expect(search).not_to be_valid
    end

    it 'is valid if valid postcode entered' do
      search = described_class.new(postcode: 'NW9 8TE', name: nil)

      expect(search).to be_valid
    end
  end
end
