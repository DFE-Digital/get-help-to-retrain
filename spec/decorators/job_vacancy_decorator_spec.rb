require 'rails_helper'

RSpec.describe JobVacancyDecorator do
  describe '#company_and_location' do
    it 'returns the formatted company and location' do
      job_vacancy = JobVacancy.new(
        'company' => 'Amazon',
        'location' => 'London, UK'
      )
      decorated_vacancy = described_class.new(job_vacancy)

      expect(decorated_vacancy.company_and_location).to eq('<strong>Amazon</strong> - London, UK')
    end

    it 'returns the formatted company if there is no location' do
      job_vacancy = JobVacancy.new('company' => 'Amazon')
      decorated_vacancy = described_class.new(job_vacancy)

      expect(decorated_vacancy.company_and_location).to eq('<strong>Amazon</strong>')
    end

    it 'returns the location if there is no company' do
      job_vacancy = JobVacancy.new('location' => 'London, UK')
      decorated_vacancy = described_class.new(job_vacancy)

      expect(decorated_vacancy.company_and_location).to eq('London, UK')
    end

    it 'returns nothing if no company or location available' do
      decorated_vacancy = described_class.new(JobVacancy.new({}))

      expect(decorated_vacancy.company_and_location).to be_empty
    end
  end

  describe '#formatted_closing_date' do
    it 'returns the formatted closing date' do
      job_vacancy = JobVacancy.new('closing' => '2019-10-11T18:56:40')
      decorated_vacancy = described_class.new(job_vacancy)

      expect(decorated_vacancy.formatted_closing_date).to eq('11 October 2019')
    end

    it 'returns nil if closing date is empty' do
      job_vacancy = JobVacancy.new('closing' => '')
      decorated_vacancy = described_class.new(job_vacancy)

      expect(decorated_vacancy.formatted_closing_date).to be_nil
    end

    it 'returns nil if closing date is missing' do
      decorated_vacancy = described_class.new(JobVacancy.new({}))

      expect(decorated_vacancy.formatted_closing_date).to be_nil
    end
  end

  describe '#formatted_date_posted' do
    it 'returns the posted date formatted' do
      job_vacancy = JobVacancy.new('posted' => '2019-10-11T18:56:40')
      decorated_vacancy = described_class.new(job_vacancy)

      expect(decorated_vacancy.formatted_date_posted).to eq('11 October 2019')
    end

    it 'returns nil if posted date is empty' do
      job_vacancy = JobVacancy.new('posted' => '')
      decorated_vacancy = described_class.new(job_vacancy)

      expect(decorated_vacancy.formatted_date_posted).to be_nil
    end

    it 'returns nil if posted date is missing' do
      decorated_vacancy = described_class.new(JobVacancy.new({}))

      expect(decorated_vacancy.formatted_date_posted).to be_nil
    end
  end
end
