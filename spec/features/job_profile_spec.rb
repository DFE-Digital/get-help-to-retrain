require 'rails_helper'

RSpec.feature 'Job profile spec' do
  scenario 'Page has correct title including job profile name' do
    create(:job_profile, :with_html_content, name: 'Acrobat', slug: 'acrobat')

    visit(job_profile_path('acrobat'))

    expect(page).to have_content('How to become an acrobat')
  end

  scenario 'Alternative titles has the structure Similar types of work include: xxxxx' do
    job_profile = create(:job_profile, :with_html_content, alternative_titles: 'Therapy master, dog walker, trainer')

    visit(job_profile_path(job_profile.slug))

    expect(page).to have_content('Similar types of work include: therapy master, dog walker, trainer')
  end

  scenario 'Apprenticeship section is not rendered unless it exists' do
    job_profile = create(:job_profile, :with_html_content)

    visit(job_profile_path(job_profile.slug))

    expect(page).not_to have_content('Apprenticeship')
  end

  xscenario 'User can see number of job vacancies near them' do
    job_vacancy_search = instance_double(JobVacancySearch, count: 3)
    allow(JobVacancySearch).to receive(:new).and_return(job_vacancy_search)
    job_profile = create(:job_profile, :with_html_content)

    user_enters_location
    visit(job_profile_path(job_profile.slug))

    expect(page).to have_content('At least 3 vacancies')
  end

  xscenario 'User can see singular job vacancy if only one near them' do
    job_vacancy_search = instance_double(JobVacancySearch, count: 1)
    allow(JobVacancySearch).to receive(:new).and_return(job_vacancy_search)
    job_profile = create(:job_profile, :with_html_content)

    user_enters_location
    visit(job_profile_path(job_profile.slug))

    expect(page).to have_content('At least 1 vacancy')
  end

  xscenario 'User can see no job vacancies near them if none are available' do
    job_vacancy_search = instance_double(JobVacancySearch, count: 0)
    allow(JobVacancySearch).to receive(:new).and_return(job_vacancy_search)
    job_profile = create(:job_profile, :with_html_content)

    user_enters_location
    visit(job_profile_path(job_profile.slug))

    expect(page).to have_content('At the moment the Find a job service is advertising no vacancies')
  end

  scenario 'User does not see job vacancies if API is down' do
    job_vacancy_search = instance_double(JobVacancySearch)
    allow(JobVacancySearch).to receive(:new).and_return(job_vacancy_search)
    allow(job_vacancy_search).to receive(:count).and_raise(FindAJobService::APIError)

    job_profile = create(:job_profile, :with_html_content)

    user_enters_location
    visit(job_profile_path(job_profile.slug))

    expect(page).not_to have_content('Jobs in your area')
  end

  scenario 'User does not see job vacancies if no postcode supplied' do
    job_vacancy_search = instance_double(JobVacancySearch)
    allow(JobVacancySearch).to receive(:new).and_return(job_vacancy_search)
    allow(job_vacancy_search).to receive(:count).and_raise(FindAJobService::APIError)

    job_profile = create(:job_profile, :with_html_content)

    visit(job_profile_path(job_profile.slug))

    expect(page).not_to have_content('Jobs in your area')
  end

  scenario 'User can target a job profile' do
    job_profile = create(:job_profile, :with_html_content)

    visit(job_profile_path(job_profile.slug))
    click_on('Select this type of work')

    expect(page).to have_current_path(training_questions_path)
  end

  scenario 'The targetted job profile is tracked in GA' do
    tracking_service = instance_spy(TrackingService)
    job_profile = create(:job_profile, :with_html_content)

    allow(TrackingService).to receive(:new).and_return(tracking_service)

    visit(job_profile_path(job_profile.slug))
    click_on('Select this type of work')

    expect(tracking_service).to have_received(:track_events).with(
      props:
      [
        {
          key: :selected_job,
          label: job_profile.name,
          value: 'click'
        }
      ]
    )
  end

  scenario 'User can see their skills gap in section skills need to develop' do
    job_profile = create(
      :job_profile,
      :with_html_content,
      skills: [
        create(:skill, name: 'Chameleon-like blend in tactics'),
        create(:skill, name: 'License to kill'),
        create(:skill, name: 'Baldness')
      ]
    )
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('Chameleon-like blend in tactics', allow_label_click: true)
    uncheck('License to kill', allow_label_click: true)
    click_on('Select these skills')
    visit(job_profile_path(job_profile.slug))

    expect(page.all('h3:contains("Skills you may need to develop") + ul.govuk-list li').collect(&:text)).to eq(
      ['Chameleon-like blend in tactics', 'License to kill']
    )
  end

  scenario 'User can see their existing skills in section skills you have' do
    job_profile = create(
      :job_profile,
      :with_html_content,
      skills: [
        create(:skill, name: 'Chameleon-like blend in tactics'),
        create(:skill, name: 'License to kill'),
        create(:skill, name: 'Baldness')
      ]
    )
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('License to kill', allow_label_click: true)
    click_on('Select these skills')
    visit(job_profile_path(job_profile.slug))

    expect(page.all('h3:contains("Skills you have") + ul.govuk-list li').collect(&:text)).to eq(
      ['Chameleon-like blend in tactics', 'Baldness']
    )
  end

  scenario 'User can see all skills under Skills need to develop if no skills selected' do
    job_profile = create(
      :job_profile,
      :with_html_content,
      skills: [
        create(:skill, name: 'Chameleon-like blend in tactics'),
        create(:skill, name: 'License to kill'),
        create(:skill, name: 'Baldness')
      ]
    )
    visit(job_profile_path(job_profile.slug))

    expect(page.all('h3:contains("Skills you may need to develop") + ul.govuk-list li').collect(&:text)).to eq(
      ['Chameleon-like blend in tactics', 'License to kill', 'Baldness']
    )
  end

  scenario 'User does not see skills you have if no skills selected' do
    job_profile = create(
      :job_profile,
      :with_html_content,
      skills: [
        create(:skill, name: 'Chameleon-like blend in tactics'),
        create(:skill, name: 'License to kill'),
        create(:skill, name: 'Baldness')
      ]
    )
    visit(job_profile_path(job_profile.slug))

    expect(page).not_to have_content('Skills you have')
  end

  scenario 'User can see all skills under skills you have if all skills selected' do
    job_profile = create(
      :job_profile,
      :with_html_content,
      skills: [
        create(:skill, name: 'Chameleon-like blend in tactics'),
        create(:skill, name: 'License to kill'),
        create(:skill, name: 'Baldness')
      ]
    )
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')
    visit(job_profile_path(job_profile.slug))

    expect(page.all('h3:contains("Skills you have") + ul.govuk-list li').collect(&:text)).to eq(
      ['Chameleon-like blend in tactics', 'License to kill', 'Baldness']
    )
  end

  scenario 'User does not see Skills you may need to develop if all skills selected' do
    job_profile = create(
      :job_profile,
      :with_html_content,
      skills: [
        create(:skill, name: 'Chameleon-like blend in tactics'),
        create(:skill, name: 'License to kill'),
        create(:skill, name: 'Baldness')
      ]
    )
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')
    visit(job_profile_path(job_profile.slug))

    expect(page).not_to have_content('Skills you may need to develop')
  end

  def user_enters_location
    visit(your_information_path)
    fill_in('user_personal_data[first_name]', with: 'John')
    fill_in('user_personal_data[last_name]', with: 'Mayer')
    fill_in('user_personal_data[postcode]', with: 'NW118QE')
    fill_in('user_personal_data[birth_day]', with: '1')
    fill_in('user_personal_data[birth_month]', with: '1')
    fill_in('user_personal_data[birth_year]', with: DateTime.now.year - 20)
    choose('user_personal_data[gender]', option: 'male')

    click_on('Continue')
  end
end
