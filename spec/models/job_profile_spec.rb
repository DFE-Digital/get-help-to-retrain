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

    before { job_profile.scrape }

    it 'updates name with scraped title' do
      expect(job_profile.name).to eq 'Admin assistant'
    end

    it 'updates description with scraped description' do
      expect(job_profile.description).to match 'organising meetings'
    end

    it 'updates content with scraped body' do
      expect(job_profile.content).to match 'National Careers Service'
    end

    it 'updates skills with scraped skill names' do
      expect(job_profile.skills).to include customer_service
    end
  end

  describe 'content parsing' do
    let(:job_profile) { build_stubbed(:job_profile, content: html_body) }

    context 'salary range' do
      let(:html_body) {
        '<div id="Salary" class="column-40 job-profile-heroblock">
              <h2>
                  Average salary
                      <span>(a year)</span>
                              </h2>
              <div class="job-profile-salary job-profile-heroblock-content">
                      <p class="dfc-code-jpsstarter">£18,000 <span>Starter</span></p>
                      <i class="sr-hidden">to</i>
                      <p class="dfc-code-jpsexperienced">£30,000 <span>Experienced</span></p>
              </div>
          </div>'
      }

      let(:expected_values) {
        {
          min: '£18,000',
          max: '£30,000'
        }
      }

      it 'extracts the correct date range values' do
        expect(job_profile.salary).to eq expected_values
      end
    end

    context 'working hours' do
      let(:html_body) {
        '<div id="WorkingHours" class="column-30 job-profile-heroblock">
          <h2>Typical hours <span>(a week)</span></h2>
          <div class="job-profile-hours job-profile-heroblock-content">
            <p class="dfc-code-jphours">
          37 to 39  <span class="dfc-code-jpwhoursdetail">a week</span>
            </p>
          </div>
        </div>'
      }

      let(:expected_values) {
        '37-39'
      }


      it 'extracts the correct date range values' do
        expect(job_profile.working_hours).to eq expected_values
      end
    end
  end
end
