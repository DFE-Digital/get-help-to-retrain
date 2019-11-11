require 'rails_helper'

RSpec.feature 'Jobs near me', type: :feature do
  background do
    enable_feature! :action_plan
  end

  scenario 'User can navigate to jobs near me page from action plan' do
    user_targets_a_job

    expect(page).to have_current_path(jobs_near_me_path)
  end

  scenario 'User is redirected to task list page if no target job selected' do
    visit(jobs_near_me_path)

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'User can see jobs near their postcode from PID form' do
    find_a_job_service = instance_double(
      FindAJobService,
      job_vacancies: {
        'pager' => { 'total_entries' => 1 },
        'jobs' => [{}]
      }
    )
    allow(FindAJobService).to receive(:new).and_return(find_a_job_service)
    fill_in_postcode
    user_targets_a_job

    expect(find_field('postcode').value).to eq 'NW6 8ET'
  end

  scenario 'Users can update their session postcode if there was none there' do
    find_a_job_service = instance_double(
      FindAJobService,
      job_vacancies: {
        'pager' => { 'total_entries' => 1 },
        'jobs' => [{}]
      }
    )
    allow(FindAJobService).to receive(:new).and_return(find_a_job_service)
    user_targets_a_job
    fill_in('postcode', with: 'NW6 1JF')
    find('.search-button-results').click
    visit(jobs_near_me_path)

    expect(find_field('postcode').value).to eq('NW6 1JF')
  end

  scenario 'Users can update their session postcode if it already existed' do
    fill_in_postcode
    find_a_job_service = instance_double(
      FindAJobService,
      job_vacancies: {
        'pager' => { 'total_entries' => 1 },
        'jobs' => [{}]
      }
    )
    allow(FindAJobService).to receive(:new).and_return(find_a_job_service)
    user_targets_a_job
    fill_in('postcode', with: 'NW6 1JF')
    find('.search-button-results').click
    visit(jobs_near_me_path)

    expect(find_field('postcode').value).to eq('NW6 1JF')
  end

  scenario 'User can see jobs for their targeted job' do
    find_a_job_service = instance_double(
      FindAJobService,
      job_vacancies: {
        'pager' => { 'total_entries' => 1 },
        'jobs' => [{}]
      }
    )
    allow(FindAJobService).to receive(:new).and_return(find_a_job_service)
    fill_in_postcode
    user_targets_a_job

    expect(page).to have_text('Admin assistant jobs near me')
  end

  scenario 'Users can find jobs near them with postcode' do
    find_a_job_service = instance_double(
      FindAJobService,
      job_vacancies: {
        'pager' => { 'total_entries' => 1 },
        'jobs' => [{}]
      }
    )
    allow(FindAJobService).to receive(:new).and_return(find_a_job_service)
    fill_in_postcode
    user_targets_a_job

    expect(page).to have_selector('ul.govuk-list li', count: 1)
  end

  scenario 'paginates results of search' do
    find_a_job_service = instance_double(
      FindAJobService,
      job_vacancies: {
        'pager' => { 'total_entries' => 52 },
        'jobs' => (1..52).map { { 'title' => 'Assistant' } }
      }
    )
    allow(FindAJobService).to receive(:new).and_return(find_a_job_service)
    fill_in_postcode
    user_targets_a_job

    expect(page).to have_selector('ul.govuk-list li', count: 50)
  end

  scenario 'allows user to paginate through results' do
    find_a_job_service = instance_double(
      FindAJobService,
      job_vacancies: {
        'pager' => { 'total_entries' => 52 },
        'jobs' => (1..52).map { { 'title' => 'Assistant' } }
      }
    )
    allow(FindAJobService).to receive(:new).and_return(find_a_job_service)
    fill_in_postcode
    user_targets_a_job
    click_on('Next')

    expect(page).to have_selector('ul.govuk-list li', count: 2)
  end

  scenario 'User cannot see a list of jobs near them without postcode' do
    user_targets_a_job

    # TODO: real content pending
    expect(page).to have_text('0 job vacancies found')
  end

  scenario 'User gets relevant messaging on jobs near them without postcode' do
    user_targets_a_job

    expect(page).to have_text(/Enter a postcode/)
  end

  scenario 'User gets relevant messaging if their postcode is not valid' do
    user_targets_a_job
    fill_in('postcode', with: 'NW6 8E')
    find('.search-button-results').click

    expect(page).to have_text(/Enter a valid postcode/)
  end

  scenario 'User gets relevant messaging if no address is entered' do
    user_targets_a_job
    find('.search-button-results').click

    expect(page).to have_text(/Enter a postcode/)
  end

  scenario 'User gets relevant messaging if there is an API error' do
    find_a_job_service = instance_double(FindAJobService)
    allow(FindAJobService).to receive(:new).and_return(find_a_job_service)
    allow(find_a_job_service).to receive(:job_vacancies).and_raise(FindAJobService::APIError)

    user_targets_a_job
    fill_in('postcode', with: 'NW6 9ET')
    find('.search-button-results').click

    expect(page).to have_text(/Sorry, there is a problem with this service/)
  end

  def user_targets_a_job
    create(:job_profile, :with_html_content, name: 'Admin assistant').tap do |job_profile|
      visit(job_profile_path(job_profile.slug))
      click_on('Target this type of work')
      click_on('Show jobs near me')
    end
  end

  def fill_in_postcode
    visit(your_information_path)
    fill_in('user_personal_data[first_name]', with: 'John')
    fill_in('user_personal_data[last_name]', with: 'Mayer')
    fill_in('user_personal_data[postcode]', with: 'NW6 8ET')
    fill_in('user_personal_data[birth_day]', with: '1')
    fill_in('user_personal_data[birth_month]', with: '1')
    fill_in('user_personal_data[birth_year]', with: DateTime.now.year - 20)
    choose('user_personal_data[gender]', option: 'male')
    click_on('Continue')
  end
end
