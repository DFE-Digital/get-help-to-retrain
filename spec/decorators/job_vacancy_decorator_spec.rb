require 'rails_helper'

RSpec.describe JobVacancyDecorator do
  describe '#company_and_location' do
    it 'returns the formatted company and location' do
      job_vacancy = JobVacancy.new(
        'company' => 'Amazon',
        'location' => 'London, UK'
      )
      decorated_vacancy = described_class.new(job_vacancy)

      expect(decorated_vacancy.company_and_location).to eq('<b>Amazon</b> - London, UK')
    end

    it 'returns the formatted company if there is no location' do
      job_vacancy = JobVacancy.new('company' => 'Amazon')
      decorated_vacancy = described_class.new(job_vacancy)

      expect(decorated_vacancy.company_and_location).to eq('<b>Amazon</b>')
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
end
