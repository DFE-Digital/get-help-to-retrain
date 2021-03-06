require 'rails_helper'

RSpec.describe JobProfile do
  let(:category) { build_stubbed(:category) }
  let(:skill) { build_stubbed(:skill) }
  let(:recommended_job) { build_stubbed(:job_profile) }
  let(:discouraged_job) { build_stubbed(:job_profile, :excluded) }

  describe '#recommended' do
    it 'is true for recommended job profiles' do
      expect(recommended_job).to be_recommended
    end

    it 'is false for non recommended job profiles' do
      expect(discouraged_job).not_to be_recommended
    end
  end

  describe 'relationships' do
    let(:related_job_profile) { build_stubbed(:job_profile) }

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

    it 'has many and belongs to many related_job_profiles' do
      discouraged_job.related_job_profiles << related_job_profile

      expect(discouraged_job.related_job_profiles).to contain_exactly(related_job_profile)
    end
  end

  describe '.import' do
    subject(:import) { described_class.import('foo', 'https://foobar.com') }

    context 'with new job profile' do
      it 'creates the job profile' do
        expect { import }.to change(described_class, :count).by(1)
      end

      it 'sets the default name from slug' do
        import
        expect(described_class.last.name).to eq 'Foo'
      end
    end

    context 'with existing job profile' do
      before { create :job_profile, slug: 'foo', name: 'Bar' }

      it 'does not creates a new job profile' do
        expect { import }.not_to change(described_class, :count)
      end

      it 'does not overwrite existing name' do
        import
        expect(described_class.last.name).to eq 'Bar'
      end
    end
  end

  describe '#scrape', vcr: { cassette_name: 'explore_my_careers_job_profile' } do
    let(:url) { 'https://nationalcareers.service.gov.uk/job-profiles/lifeguard' }
    let(:job_profile) { build :job_profile, source_url: url }
    let!(:customer_service) { create :skill, name: 'customer service skills' }

    context 'with no persisted job profiles' do
      before { job_profile.scrape }

      it 'updates name with scraped title' do
        expect(job_profile.name).to eq 'Lifeguard'
      end

      it 'updates description with scraped description' do
        expect(job_profile.description).to match 'look after swimming areas'
      end

      it 'updates salary minimum with scraped salary' do
        expect(job_profile.salary_min).to eq 13_000
      end

      it 'updates salary maximum with scraped salary' do
        expect(job_profile.salary_max).to eq 29_000
      end

      it 'updates content with scraped body' do
        expect(job_profile.content).to match 'National Careers Service'
      end

      it 'updates skills with scraped skill names' do
        expect(job_profile.skills).to include customer_service
      end
    end

    context 'with persisted job profiles' do
      let(:job_profile) { create :job_profile, slug: 'data-entry-clerk', source_url: url }

      before do
        create :job_profile, slug: 'swimming-teacher'
        create :job_profile, slug: 'non-existing-profile'

        job_profile.scrape
      end

      it 'updates the related_profiles with scraped related job profiles data' do
        expect(job_profile.related_job_profiles.pluck(:slug)).to contain_exactly(
          'swimming-teacher'
        )
      end
    end
  end

  describe '#with_skills' do
    let(:skill_1) {
      build_stubbed(:skill, name: 'Skill1')
    }

    let(:skill_2) {
      build_stubbed(:skill, name: 'Skill2')
    }

    let(:skill_3) {
      build_stubbed(:skill, name: 'Skill3')
    }

    let(:job_profile) {
      build_stubbed(:job_profile, skills: [skill_1, skill_2, skill_3])
    }

    let(:expected_hash) {
      {
        profile_id: job_profile.id,
        profile_slug: job_profile.slug,
        name: job_profile.name,
        skills: {
          skill_2.id => 'Skill2',
          skill_3.id => 'Skill3'
        }
      }
    }

    it 'returns a hash with just the passed skill_ids' do
      expect(job_profile.with_skills([skill_2.id, skill_3.id])).to eq(expected_hash)
    end
  end
end
