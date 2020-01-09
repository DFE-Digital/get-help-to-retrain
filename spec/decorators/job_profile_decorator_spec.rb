require 'rails_helper'

RSpec.describe JobProfileDecorator do
  subject(:job_profile) { described_class.new(model) }

  let(:model) { build_stubbed :job_profile, content: html_body }

  describe '.decorate' do
    let(:model) { build_stubbed :job_profile, :with_html_content }

    it 'decorates an array of job profiles' do
      decorated = described_class.decorate([model, model])
      expect(decorated.first).to be_a described_class
    end
  end

  describe '#salary_range' do
    context 'with defined minimum and maximum' do
      let(:model) { build_stubbed :job_profile, salary_min: 18_000, salary_max: 30_000 }

      it 'formats the salary range' do
        expected_salary_range = <<~HTML.gsub(/\n/, '')
          <div class="salary-columns">
          <div class="salary-column">
          <p class="govuk-!-margin-0">£18,000<br />(starter)</p>
          </div>
          <div class="salary-column">
          <p class="govuk-!-margin-0 salary-separator"> – </p>
          </div>
          <div class="salary-column">
          <p class="govuk-!-margin-0">£30,000<br />(experienced)</p>
          </div>
          </div>
        HTML

        expect(job_profile.salary_range).to eq(expected_salary_range)
      end
    end

    context 'with missing minimum or maximum' do
      let(:model) { build_stubbed :job_profile }

      it 'returns Variable' do
        expect(job_profile.salary_range).to eq 'Variable'
      end
    end
  end

  describe '#growth_icon' do
    context 'when the job is falling' do
      let(:model) { build(:job_profile, :falling) }

      it 'returns a falling arrow css class' do
        expect(job_profile.growth_icon).to eq 'arrow-falling-icon'
      end
    end

    context 'when the job is stable' do
      let(:model) { build(:job_profile, :stable) }

      it 'returns a stable arrow css class' do
        expect(job_profile.growth_icon).to eq 'arrow-stable-icon'
      end
    end

    context 'when the job is growing' do
      let(:model) { build(:job_profile, :growing) }

      it 'returns a growing arrow css class' do
        expect(job_profile.growth_icon).to eq 'arrow-growing-icon'
      end
    end

    context 'when the job is growing strongly' do
      let(:model) { build(:job_profile, :growing_strongly) }

      it 'returns a growing strongly arrow css class' do
        expect(job_profile.growth_icon).to eq 'arrow-growing-strongly-icon'
      end
    end

    context 'when the job profile has no growth score' do
      let(:model) { build_stubbed :job_profile, growth: nil }

      it 'returns an empty css class' do
        expect(job_profile.growth_icon).to eq ''
      end
    end
  end

  describe '#growth_type' do
    context 'when the job is falling' do
      let(:model) { build(:job_profile, :falling) }

      it 'returns the type falling' do
        expect(job_profile.growth_type).to eq 'Falling'
      end
    end

    context 'when the job is stable' do
      let(:model) { build(:job_profile, :stable) }

      it 'returns the type stable' do
        expect(job_profile.growth_type).to eq 'Stable'
      end
    end

    context 'when the job is growing' do
      let(:model) { build(:job_profile, :growing) }

      it 'returns the type growing' do
        expect(job_profile.growth_type).to eq 'Growing'
      end
    end

    context 'when the job is growing strongly' do
      let(:model) { build(:job_profile, :growing_strongly) }

      it 'returns the type growing strongly' do
        expect(job_profile.growth_type).to eq 'Growing strongly'
      end
    end

    context 'when the job is missing the growth score' do
      let(:model) { build(:job_profile, growth: nil) }

      it 'returns nil' do
        expect(job_profile.growth_type).to eq('No data available')
      end
    end
  end

  describe '#growth_explanation' do
    context 'when the job is falling' do
      let(:model) { build(:job_profile, :falling) }

      it 'returns the explanation for falling score' do
        expect(job_profile.growth_explanation).to eq I18n.t(:falling, scope: :job_growth_explanation)
      end
    end

    context 'when the job is stable' do
      let(:model) { build(:job_profile, :stable) }

      it 'returns the explanation for stable score' do
        expect(job_profile.growth_explanation).to eq I18n.t(:stable, scope: :job_growth_explanation)
      end
    end

    context 'when the job is growing' do
      let(:model) { build(:job_profile, :growing) }

      it 'returns the explanation for growing score' do
        expect(job_profile.growth_explanation).to eq I18n.t(:growing, scope: :job_growth_explanation)
      end
    end

    context 'when the job is growing strongly' do
      let(:model) { build(:job_profile, :growing_strongly) }

      it 'returns the explanation for growing strongly score' do
        expect(job_profile.growth_explanation).to eq I18n.t(:growing_strongly, scope: :job_growth_explanation)
      end
    end

    context 'when the job is missing the growth score' do
      let(:model) { build(:job_profile, growth: nil) }

      it 'returns nil' do
        expect(job_profile.growth_explanation).to be nil
      end
    end
  end

  describe '#how_to_become' do
    let(:html_body) do
      '<section id="HowToBecome">
        <h2 class="heading-large job-profile-heading">How to become an RAF officer</h2>
       </section>'
    end

    it 'extracts the correct heading' do
      expect(job_profile.how_to_become).to eq 'How to become an RAF officer'
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

  describe '#additional_hero_copy' do
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

    it 'extracts the additional copy' do
      expect(job_profile.additional_hero_copy).to match(
        ['Archivists look after and preserve documents.']
      )
    end
  end

  describe '#section' do
    let(:section_key) { :apprenticeship }

    let(:html_body) do
      '<section class="job-profile-subsection" id="Apprenticeship">
        <h3>Apprenticeship</h3>
        <div class="job-profile-subsection-content">
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
        '<p class="govuk-body-m">You could take a software developer higher apprenticeship</p>',
        '<p class="govuk-body-m">You could also do a digital and technology solutions degree apprenticeship.</p>'
      ]
    end

    let(:deleted_tags) do
      [
        '<h3>Apprenticeship</h3>',
        '<h4>Entry requirements</h4>',
        '<p>You\'ll usually need:</p>',
        '<ul class="list-reqs">',
        '<li>4 or 5 GCSEs at grades 9 to 4 (A* to C) and college qualifications like A levels</li>'
      ]
    end

    let(:mutated_html_body) do
      job_profile.section(section_key)
    end

    context 'with unknown section' do
      let(:section_key) { :foo }

      it 'returns nil' do
        expect(mutated_html_body).to be_nil
      end
    end

    context 'when links present' do
      let(:html_body) do
        '<section class="job-profile-subsection" id="Apprenticeship">
          <h3>Apprenticeship</h3><div class="job-profile-subsection-content">
            <h4>Some things you might need</h4>
            <ul class="list-reqs">
              <li><a href="google.com">4 or 5 GCSEs at grades 9 to 4 (A* to C) and college qualifications like A levels</a></li>
            </ul>
          </div>
        </section>'
      end

      let(:mutated_tags) do
        [
          '<h2 class="govuk-heading-m">Some things you might need</h2>',
          '<ul class="govuk-list govuk-list--bullet">',
          '<li>4 or 5 GCSEs at grades 9 to 4 (A* to C) and college qualifications like A levels</li>'
        ]
      end

      it 'removes all links' do
        expect(Nokogiri::HTML(mutated_html_body).xpath('//a[@href]')).to be_empty
      end

      it 'mutates the html snippet to use our styles' do
        mutated_tags.each do |tag|
          expect(mutated_html_body).to include(tag)
        end
      end
    end

    it 'mutates the html snippet to use our styles' do
      mutated_tags.each do |tag|
        expect(mutated_html_body).to include(tag)
      end
    end

    it 'removes unwanted copy' do
      deleted_tags.each do |tag|
        expect(mutated_html_body).not_to include(tag)
      end
    end
  end

  describe '#skills_match' do
    subject(:job_profile) { described_class.new(build(:job_profile)) }

    it 'returns nothing if no score given' do
      expect(job_profile.skills_match(nil)).to be_nil
    end

    it 'returns Low if score is less than 25' do
      expect(job_profile.skills_match(23.333)).to eq('Low')
    end

    it 'returns Reasonable if score is between 25 and 50' do
      expect(job_profile.skills_match(45.55)).to eq('Reasonable')
    end

    it 'returns Good if score is between 50 and 75' do
      expect(job_profile.skills_match(66.667)).to eq('Good')
    end

    it 'returns Excellent if score is more than 75' do
      expect(job_profile.skills_match(88.8)).to eq('Excellent')
    end
  end
end
