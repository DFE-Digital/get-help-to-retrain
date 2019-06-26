require 'rails_helper'

RSpec.describe JobProfileDecorator do
  let(:job_profile) do
    described_class.new(
      build_stubbed(:job_profile, content: html_body)
    )
  end

  describe '#salary_range' do
    let(:html_body) do
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
    end

    it 'extracts the correct date range values' do
      expect(job_profile.salary_range).to eq '£18,000 - £30,000'
    end
  end

  describe '#working_hours' do
    let(:html_body) do
      '<div id="WorkingHours" class="column-30 job-profile-heroblock">
        <h2>Typical hours <span>(a week)</span></h2>
        <div class="job-profile-hours job-profile-heroblock-content">
          <p class="dfc-code-jphours">
        37 to 39  <span class="dfc-code-jpwhoursdetail">a week</span>
          </p>
        </div>
      </div>'
    end

    let(:expected_values) do
      '37 - 39'
    end

    it 'extracts the correct date range values' do
      expect(job_profile.working_hours).to eq expected_values
    end
  end

  describe '#working_hours_patterns' do
    let(:html_body) do
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
    end

    let(:expected_values) do
      'Between 8am and 6pm'
    end

    it 'extracts the correct date range values' do
      expect(job_profile.working_hours_patterns).to eq expected_values
    end
  end

  describe '#hero_copy' do
    let(:html_body) do
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
    end

    it 'extracts the hero copy' do
      expect(job_profile.hero_copy).to eq 'Archivist'
    end

    context 'when sub hero copy exists' do
      it 'extracts the sub hero copy' do
        expect(job_profile.sub_hero_copy).to eq 'Curator, records manager'
      end
    end

    context 'when sub hero copy is missing' do
      let(:html_body) do
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
                  <p>Archivists look after and preserve documents.</p>
                </div>
              </div>
            </div>
          </div>
        </header>'
      end

      it 'returns from the method' do
        expect(job_profile.sub_hero_copy).to be nil
      end
    end

    it 'extracts the additional copy' do
      expect(job_profile.additional_hero_copy).to match(
        ['Archivists look after and preserve documents.']
      )
    end
  end

  describe '#section' do
    let(:xpath) do
      "//section[@id='Apprenticeship']".freeze
    end

    let(:html_body) do
      '<section class="job-profile-subsection" id="Apprenticeship">
        <h3>Apprenticeship</h3><div class="job-profile-subsection-content">
          <p>You could take a software developer higher apprenticeship</p>
          <p>You could also do a digital and technology solutions degree apprenticeship.</p>
          <h4>Entry requirements</h4>
          <p>You\'ll usually need:</p>
          <ul class="list-reqs">
            <li>4 or 5 GCSEs at grades 9 to 4 (A* to C) and college qualifications like A levels</li>
          </ul>
        </div>
      </section>'
    end

    let(:mutated_tags) do
      [
        '<h2 class="govuk-heading-m">Apprenticeship</h2>',
        '<p class="govuk-body-m">You could take a software developer higher apprenticeship</p>',
        '<p class="govuk-body-m">You could also do a digital and technology solutions degree apprenticeship.</p>',
        '<h3 class="govuk-heading-s">Entry requirements</h3>',
        '<p class="govuk-body-m">You\'ll usually need:</p>',
        '<ul class="govuk-list govuk-list--bullet">',
        '<li>4 or 5 GCSEs at grades 9 to 4 (A* to C) and college qualifications like A levels</li>'
      ]
    end

    let(:mutated_html_body) do
      job_profile.section(xpath: xpath)
    end

    context 'when links present' do
      let(:html_body) do
        '<section class="job-profile-subsection" id="Apprenticeship">
          <h3>Apprenticeship</h3><div class="job-profile-subsection-content">
            <p>You could take a software developer higher apprenticeship</p>
            <p>You could also do a digital and technology solutions degree apprenticeship.</p>
            <h4><a href="google.com">Entry requirements</a></h4>
            <p>You\'ll usually need:</p>
            <ul class="list-reqs">
              <li><a href="google.com">4 or 5 GCSEs at grades 9 to 4 (A* to C) and college qualifications like A levels<a></li>
            </ul>
          </div>
        </section>'
      end

      it 'removes all links' do
        expect(Nokogiri::HTML(mutated_html_body).xpath('//a[@href]')).to be_empty
      end
    end

    it 'mutates the html snippet to use our styles' do
      mutated_tags.each do |tag|
        expect(mutated_html_body).to include(tag)
      end
    end
  end
end
