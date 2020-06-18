require 'rails_helper'

RSpec.feature 'Jobs near me', type: :feature do
  background do
    fill_pid_form
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
    user_targets_a_job

    expect(find_field('postcode').value).to eq 'NW6 8ET'
  end

  scenario 'Users can update their session postcode if it already existed' do
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
    click_on('Apply filters')
    visit(jobs_near_me_path)

    expect(find_field('postcode').value).to eq('NW6 1JF')
  end

  scenario 'Users will by default see a 20 miles distance on an empty session' do
    find_a_job_service = instance_double(
      FindAJobService,
      job_vacancies: {
        'pager' => { 'total_entries' => 1 },
        'jobs' => [{}]
      }
    )
    allow(FindAJobService).to receive(:new).and_return(find_a_job_service)
    user_targets_a_job

    expect(page).to have_select('distance', selected: 'Up to 20 miles')
  end

  scenario 'Users can update the distance on the session' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    find_a_job_service = instance_double(
      FindAJobService,
      job_vacancies: {
        'pager' => { 'total_entries' => 1 },
        'jobs' => [{}]
      }
    )
    allow(FindAJobService).to receive(:new).and_return(find_a_job_service)
    user_targets_a_job

    fill_in('postcode', with: 'NW6 8ET')
    select('Up to 40 miles', from: 'distance')
    click_on('Apply filters')

    visit(jobs_near_me_path)

    expect(page).to have_select('distance', selected: 'Up to 40 miles')
  end

  scenario 'Users will see the same distance that was used on Find a course section if they come from that page' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    find_a_job_service = instance_double(
      FindAJobService,
      job_vacancies: {
        'pager' => { 'total_entries' => 1 },
        'jobs' => [{}]
      }
    )
    allow(FindAJobService).to receive(:new).and_return(find_a_job_service)

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    select('Up to 10 miles', from: 'distance')
    click_on('Apply filters')

    user_targets_a_job

    expect(page).to have_select('distance', selected: 'Up to 10 miles')
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
    user_targets_a_job

    expect(page).to have_text('Admin assistant jobs near you')
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
    user_targets_a_job

    expect(page).to have_selector('ul.govuk-list li', count: 1)
  end

  scenario 'Passing an alternative_title as query string param overrides the target_job' do
    find_a_job_service = instance_double(FindAJobService)
    allow(FindAJobService).to receive(:new).and_return(find_a_job_service)
    allow(find_a_job_service).to receive(:job_vacancies).with(
      postcode: 'NW6 8ET',
      name: 'developer',
      page: 1,
      distance: 20
    ).and_return(
      'pager' => { 'total_entries' => 1 },
      'jobs' => [{}]
    )

    create(:job_profile, :with_html_content, name: 'Admin assistant').tap do |job_profile|
      visit(job_profile_path(job_profile.slug))
      click_on('Select this type of work')
      click_on('Continue')
      click_on('Continue')
      click_on('Continue')
    end

    visit(jobs_near_me_path(job_alternative_title: 'developer'))

    expect(page).to have_text('Developer jobs near you')
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
    user_targets_a_job
    click_on('Next')

    expect(page).to have_selector('ul.govuk-list li', count: 2)
  end

  scenario 'altering the page number does not throw an error' do
    find_a_job_service = instance_double(
      FindAJobService,
      job_vacancies: {
        'pager' => { 'total_entries' => 52 },
        'jobs' => (1..52).map { { 'title' => 'Assistant' } }
      }
    )
    allow(FindAJobService).to receive(:new).and_return(find_a_job_service)
    user_targets_a_job
    visit(jobs_near_me_path(page: '2asd'))

    expect(page).to have_selector('ul.govuk-list li', count: 2)
  end

  scenario 'User cannot see a list of jobs near them without postcode' do
    user_targets_a_job

    # TODO: real content pending
    expect(page).to have_text('0 job vacancies found')
  end

  scenario 'User gets relevant messaging on jobs near them without postcode' do
    user_targets_a_job
    fill_in('postcode', with: '')
    click_on('Apply filters')

    expect(page).to have_text(/Enter a postcode/)
  end

  scenario 'User gets relevant messaging if their postcode is not valid' do
    user_targets_a_job
    fill_in('postcode', with: 'NW6 8E')
    click_on('Apply filters')

    expect(page).to have_text(/Enter a valid postcode/)
  end

  scenario 'The distance is not stored on the session if the user postcode is not valid' do
    user_targets_a_job
    fill_in('postcode', with: 'NW6 8E')
    select('Up to 10 miles', from: 'distance')
    click_on('Apply filters')

    visit(jobs_near_me_path)

    expect(page).to have_select('distance', selected: 'Up to 20 miles')
  end

  scenario 'Error summary message present if no address is entered' do
    user_targets_a_job
    fill_in('postcode', with: '')
    click_on('Apply filters')

    expect(page).to have_content('There is a problem')
  end

  scenario 'Error summary contains error if no address is entered' do
    user_targets_a_job
    fill_in('postcode', with: '')
    click_on('Apply filters')

    expect(page.all('ul.govuk-error-summary__list li a').collect(&:text)).to eq(
      [
        'Enter a postcode'
      ]
    )
  end

  scenario 'User gets relevant messaging if there is an API error' do
    find_a_job_service = instance_double(FindAJobService)
    allow(FindAJobService).to receive(:new).and_return(find_a_job_service)
    allow(find_a_job_service).to receive(:job_vacancies).and_raise(FindAJobService::APIError)

    user_targets_a_job

    expect(page).to have_text(/Sorry, there is a problem with this service/)
  end

  scenario 'tracks the outcode of the searched postcode' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    user_targets_a_job
    fill_in('postcode', with: 'NW1 8ET')
    click_on('Apply filters')

    expect(tracking_service).to have_received(:track_events).with(
      props:
      [
        {
          key: :jobs_near_me_index_search,
          label: 'Jobs near me - Postcode search',
          value: 'NW1'
        }
      ]
    )
  end

  scenario 'tracks the distance filter' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    user_targets_a_job
    fill_in('postcode', with: 'NW6 8ET')
    select('Up to 10 miles', from: 'distance')
    click_on('Apply filters')

    expect(tracking_service).to have_received(:track_events).with(
      props:
      [
        {
          key: :filter_job_vacancies,
          label: 'Job distance',
          value: 'Up to 10 miles'
        }
      ]
    )
  end

  scenario 'Users without PID submitted get redirected to the landing page' do
    user_targets_a_job

    Capybara.reset_session!

    visit(jobs_near_me_path)

    expect(page).to have_current_path(root_path)
  end

  def user_targets_a_job
    create(:job_profile, :with_html_content, name: 'Admin assistant').tap do |job_profile|
      visit(job_profile_path(job_profile.slug))
      click_on('Select this type of work')
      click_on('Continue')
      click_on('Continue')
      click_on('Continue')
      click_on('Show jobs near you')
    end
  end
end
