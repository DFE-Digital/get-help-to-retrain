require 'rails_helper'

RSpec.describe JobProfile do
  let(:category) { FactoryBot.build_stubbed(:category) }
  let(:skill) { FactoryBot.build_stubbed(:skill) }
  let(:recommended_job) { FactoryBot.build_stubbed(:job_profile, :recommended) }
  let(:discouraged_job) { FactoryBot.build_stubbed(:job_profile) }

  describe '#recommended' do
    it 'is true for recommended job profiles' do
      expect(recommended_job).to be_recommended
    end

    it 'is false for non recommended job profiles' do
      expect(discouraged_job).to_not be_recommended
    end
  end

  describe 'relationships' do
    before do
      recommended_job.categories << category
      recommended_job.skills << skill
    end

    it 'has many categories' do
      expect(recommended_job.categories).to match [category]
    end

    it 'has many skills' do
      expect(recommended_job.skills).to match [skill]
    end
  end
end
