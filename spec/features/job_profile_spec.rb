require 'rails_helper'

RSpec.feature 'Job profile spec' do
  background do
    disable_feature! :action_plan
  end

  scenario 'Page has correct title including job profile name' do
    create(:job_profile, :with_html_content, name: 'Cleric', slug: 'cleric')

    visit(job_profile_path('cleric'))

    expect(page).to have_content('How to become: cleric')
  end

  scenario 'Alternative titles has the structure Other similar jobs include: xxxxx' do
    job_profile = create(:job_profile, :with_html_content, alternative_titles: 'Therapy master, dog walker, trainer')

    visit(job_profile_path(job_profile.slug))

    expect(page).to have_content('Other similar jobs include: therapy master, dog walker, trainer')
  end

  scenario 'Page contains the Valuable skills section' do
    job_profile = create(:job_profile, :with_html_content)

    visit(job_profile_path(job_profile.slug))

    expect(page).to have_content('Valuable skills')
  end

  scenario 'User navigates to training hub page from valuable skills section' do
    job_profile = create(:job_profile, :with_html_content)

    visit(job_profile_path(job_profile.slug))

    click_on('Find a training course')

    expect(page).to have_current_path(training_hub_path)
  end

  scenario 'Page contains the Further help to change jobs section' do
    job_profile = create(:job_profile, :with_html_content)

    visit(job_profile_path(job_profile.slug))

    expect(page).to have_content('Further help to change jobs')
  end

  scenario 'User navigates to next steps page from valuable skills section' do
    job_profile = create(:job_profile, :with_html_content)

    visit(job_profile_path(job_profile.slug))

    click_on('Get help changing jobs')

    expect(page).to have_current_path(next_steps_path)
  end

  scenario 'Apprenticeship section is not rendered unless it exists' do
    job_profile = create(:job_profile, :with_html_content)

    visit(job_profile_path(job_profile.slug))

    expect(page).not_to have_content('Apprenticeship')
  end

  scenario 'Page does not have CTA: Target this type of work' do
    job_profile = create(:job_profile, :with_html_content)

    visit(job_profile_path(job_profile.slug))

    expect(page).not_to have_button('Target this type of work')
  end

  scenario 'User can see number of job vacancies near them' do
    job_vacancy_search = instance_double(JobVacancySearch, count: 3)
    allow(JobVacancySearch).to receive(:new).and_return(job_vacancy_search)
    job_profile = create(:job_profile, :with_html_content)

    user_enters_location
    visit(job_profile_path(job_profile.slug))

    expect(page).to have_content('At least 3 vacancies')
  end

  scenario 'User can see singular job vacancy if only one near them' do
    job_vacancy_search = instance_double(JobVacancySearch, count: 1)
    allow(JobVacancySearch).to receive(:new).and_return(job_vacancy_search)
    job_profile = create(:job_profile, :with_html_content)

    user_enters_location
    visit(job_profile_path(job_profile.slug))

    expect(page).to have_content('At least 1 vacancy')
  end

  scenario 'User can see no job vacancies near them if none are available' do
    job_vacancy_search = instance_double(JobVacancySearch, count: 0)
    allow(JobVacancySearch).to receive(:new).and_return(job_vacancy_search)
    job_profile = create(:job_profile, :with_html_content)

    user_enters_location
    visit(job_profile_path(job_profile.slug))

    expect(page).to have_content('there are no jobs')
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

  scenario 'User no longer sees the Valuable skills section on V2' do
    enable_feature! :action_plan

    job_profile = create(:job_profile, :with_html_content)

    visit(job_profile_path(job_profile.slug))

    expect(page).not_to have_content('Valuable skills')
  end

  scenario 'User no longer sees the Further help to change jobs section on V2' do
    enable_feature! :action_plan

    job_profile = create(:job_profile, :with_html_content)

    visit(job_profile_path(job_profile.slug))

    expect(page).not_to have_content('Further help to change jobs')
  end

  scenario 'User can target a job profile on V2' do
    enable_feature! :action_plan

    job_profile = create(:job_profile, :with_html_content)

    visit(job_profile_path(job_profile.slug))
    click_on('Target this type of work')

    expect(page).to have_current_path(action_plan_path)
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
