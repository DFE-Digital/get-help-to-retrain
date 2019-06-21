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
      expect(discouraged_job).not_to be_recommended
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

    it 'returns a job profile if a name supplied is uppercase' do
      job_profile = create(:job_profile, name: 'Beverage Dissemination Officer')

      expect(described_class.search('DISSEMINATION')).to contain_exactly(job_profile)
    end

    it 'returns a job profile if a name supplied is lowercase' do
      job_profile = create(:job_profile, name: 'BEVERAGE DISSEMINATION OFFICER')

      expect(described_class.search('beverage dissemination officer')).to contain_exactly(job_profile)
    end

    it 'returns a job profile if a name supplied is mixed case' do
      job_profile = create(:job_profile, name: 'Beverage Dissemination Officer')

      expect(described_class.search('Beverage Dissemination OfFicer')).to contain_exactly(job_profile)
    end

    it 'returns nothing if no job profile is matched' do
      create(:job_profile, name: 'Dream Alchemist')

      expect(described_class.search('Beverage Dissemination Officer')).to be_empty
    end

    it 'returns all records if empty name is supplied' do
      job_profiles = [
        create(:job_profile, name: 'Dream Alchemist'),
        create(:job_profile, name: 'Beverage Dissemination Officer')
      ]

      expect(described_class.search('')).to eq(job_profiles)
    end

    it 'returns all records if no name is supplied' do
      job_profiles = [
        create(:job_profile, name: 'Dream Alchemist'),
        create(:job_profile, name: 'Beverage Dissemination Officer')
      ]

      expect(described_class.search(nil)).to eq(job_profiles)
    end
  end

  describe '.import' do
    subject { described_class.import('foo', 'https://foobar.com') }

    context 'new job profile' do
      it 'creates the job profile' do
        expect { subject }.to change { JobProfile.count }.by(1)
      end

      it 'sets the default name from slug' do
        subject
        expect(JobProfile.last.name).to eq 'Foo'
      end
    end

    context 'existing job profile' do
      before { create :job_profile, slug: 'foo', name: 'Bar' }

      it 'does not creates a new job profile' do
        expect { subject }.to_not change { JobProfile.count }
      end

      it 'does not overwrite existing name' do
        subject
        expect(JobProfile.last.name).to eq 'Bar'
      end
    end
  end
end
