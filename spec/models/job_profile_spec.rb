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

  describe '.search' do
    it 'returns a job profile if a name has accidental spaces' do
      job_profile = create(:job_profile, name: 'Music therapist')

      expect(described_class.search('Music    therapist      ')).to contain_exactly(job_profile)
    end

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

    it 'returns no records if empty name is supplied' do
      create(:job_profile, name: 'Dream Alchemist')
      create(:job_profile, name: 'Beverage Dissemination Officer')

      expect(described_class.search('')).to be_empty
    end

    it 'returns no records if no name is supplied' do
      create(:job_profile, name: 'Dream Alchemist')
      create(:job_profile, name: 'Beverage Dissemination Officer')

      expect(described_class.search(nil)).to be_empty
    end

    it 'returns a record if value is in alternative titles only' do
      job_profile = create(:job_profile, name: 'Chef', alternative_titles: 'Cook, Kitchen manager')

      expect(described_class.search('cook')).to contain_exactly(job_profile)
    end

    it 'returns a record if value is in the description only' do
      job_profile = create(:job_profile, name: 'Chef', alternative_titles: 'Cook', description: 'Kitchen manager')

      expect(described_class.search('Kitchen manager')).to contain_exactly(job_profile)
    end

    it 'matches different records in query' do
      job_profiles = [
        create(:job_profile, name: 'Head Chef'),
        create(:job_profile, alternative_titles: 'Cook'),
        create(:job_profile, description: 'Street food traders ')
      ]

      expect(described_class.search('food cook chef')).to eq(job_profiles)
    end

    it 'matches query words as prefixes to records' do
      job_profile = create(:job_profile, name: 'Chief executive')

      expect(described_class.search('exec')).to contain_exactly(job_profile)
    end

    it 'matches query words through stemming to records' do
      job_profile = create(:job_profile, name: 'Chief executive')

      expect(described_class.search('chiefs')).to contain_exactly(job_profile)
    end

    it 'ignores unicode characters in query string' do
      job_profile = create(:job_profile, name: 'Chief executive')

      expect(described_class.search("ṩ ® chief's àⅣ <>; /")).to contain_exactly(job_profile)
    end

    it 'ignores irrelevant characters in query string' do
      job_profile = create(:job_profile, name: 'Script Writer')

      expect(described_class.search('<script> alert("PWNED!") </script>')).to contain_exactly(job_profile)
    end

    it 'guards against injection in string' do
      job_profile = create(:job_profile, name: 'Table Writer')

      expect(described_class.search('name; drop table job_profiles;')).to contain_exactly(job_profile)
    end

    it 'orders records according to matched name' do
      cook = create(:job_profile, alternative_titles: 'Cook')
      head_chef = create(:job_profile, name: 'Head Chef')
      food_trader = create(:job_profile, description: 'Street food traders ')
      kitchen_chef = create(:job_profile, name: 'Kitchen Chef')

      job_profiles_in_order = [
        head_chef,
        kitchen_chef,
        cook,
        food_trader
      ]

      expect(described_class.search('food cook chef')).to eq(job_profiles_in_order)
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
    let(:url) { 'https://nationalcareers.service.gov.uk/job-profiles/admin-assistant' }
    let(:job_profile) { build :job_profile, source_url: url }
    let!(:customer_service) { create :skill, name: 'customer service skills' }

    context 'with no persisted job profiles' do
      before { job_profile.scrape }

      it 'updates name with scraped title' do
        expect(job_profile.name).to eq 'Admin assistant'
      end

      it 'updates description with scraped description' do
        expect(job_profile.description).to match 'organising meetings'
      end

      it 'updates salary minimum with scraped salary' do
        expect(job_profile.salary_min).to eq 14_000
      end

      it 'updates salary maximum with scraped salary' do
        expect(job_profile.salary_max).to eq 30_000
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
        create :job_profile, slug: 'hotel-receptionist'
        create :job_profile, slug: 'non-existing-profile'

        job_profile.scrape
      end

      it 'updates the related_profiles with scraped related job profiles data' do
        expect(job_profile.related_job_profiles.pluck(:slug)).to contain_exactly(
          'hotel-receptionist'
        )
      end
    end
  end
end
