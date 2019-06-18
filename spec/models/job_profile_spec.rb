require 'rails_helper'

RSpec.describe JobProfile do
  let(:category) { build_stubbed(:category) }
  let(:skill) { build_stubbed(:skill) }
  let(:recommended_job) { build_stubbed(:job_profile, :recommended) }
  let(:discouraged_job) { build_stubbed(:job_profile) }

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

  describe '.search' do
    it 'returns a job profile if a name matches exactly' do
      job_profile = create(:job_profile, name: 'Beverage Dissemination Officer')

      expect(described_class.search('Beverage Dissemination Officer')).to contain_exactly(job_profile)
    end

    it 'returns a job profile if a name is like an existing job profile name' do
      job_profile = create(:job_profile, name: 'Beverage Dissemination Officer')

      expect(described_class.search('Dissemination')).to contain_exactly(job_profile)
    end

    it 'returns nothing if no job profile is matched' do
      create(:job_profile, name: 'Dream Alchemist')

      expect(described_class.search('Beverage Dissemination Officer')).to be_empty
    end
  end
end
