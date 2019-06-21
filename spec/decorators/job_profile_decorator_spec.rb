require 'rails_helper'

RSpec.describe JobProfileDecorator do
  describe 'content parsing' do
    let(:job_profile) {
      JobProfileDecorator.new(
        build_stubbed(:job_profile, content: html_body)
      )
    }

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

    context 'working hours patterns' do
      let(:html_body) {
        '<div id="WorkingHoursPatterns" class="column-30 job-profile-heroblock">
          <h2>
            You could work
          </h2>
          <div class="job-profile-pattern job-profile-heroblock-content">
            <p class="dfc-code-jpwpattern">
              between 8am and 6pm
            </p>
          </div>
        </div>'
      }

      let(:expected_values) {
        'Between 8am and 6pm'
      }

      it 'extracts the correct date range values' do
        expect(job_profile.working_hours_patterns).to eq expected_values
      end
    end

    context 'job profile hero' do
      let(:html_body) {
        '<header class="job-profile-hero">
          <div data-sf-element="Row">
            <div id="MainContentTop_T41A29498007_Col00" class="sf_colsIn" data-sf-element="Container" data-placeholder-label="Job Profile Hero Container"><div class="content-container">
              <div class="breadcrumbs govuk-breadcrumbs">
                <ol class="govuk-breadcrumbs__list">
                  <li class="govuk-breadcrumbs__list-item"><a class="govuk-breadcrumbs__link" href="/">Home: Explore careers</a></li>
                  <li class="govuk-breadcrumbs__list-item">Archivist</li>
                </ol>
              </div>
            </div>
            <div class="content-container">
              <div class="grid-row">
                <div class="column-desktop-two-thirds">
                  <h1 class="heading-xlarge"> Archivist</h1>
                  <h2 class="heading-secondary"><span class="sr-hidden">Alternative titles for this job include </span>Curator, records manager</h2>
                  <p>Archivists look after and preserve documents.</p>
                </div>
              </div>
            </div>
          </div>
        </header>'
      }

      it 'extracts the hero copy' do
        expect(job_profile.hero_copy).to eq 'Archivist'
      end

      it 'extracts the sub hero copy' do
        expect(job_profile.sub_hero_copy).to eq 'Alternative titles for this job include Curator, records manager'
      end

      it 'extracts the additional copy' do
        expect(job_profile.additional_hero_copy).to match(
          ['Archivists look after and preserve documents.']
        )
      end
    end
  end
end
