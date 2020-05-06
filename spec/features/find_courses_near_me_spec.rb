require 'rails_helper'

RSpec.feature 'Find training courses', type: :feature do
  let(:find_a_course_search_response) do
    JSON.parse(
      Rails.root.join('spec', 'fixtures', 'files', 'find_a_course_search_response.json').read
    )
  end

  scenario 'User cannot see a list of all training courses for a topic without postcode' do
    visit(courses_path(topic_id: 'maths'))

    expect(page).to have_text('0 courses found')
  end

  scenario 'The postcode is persisted on courses search page when user fills in their PID' do
    capture_user_location('NW6 1JF')
    visit(courses_path('maths'))

    expect(find_field('postcode').value).to eq 'NW6 1JF'
  end

  scenario 'Users can find training courses near them' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    find_a_course_service = instance_double(
      FindACourseService,
      search: find_a_course_search_response
    )
    allow(FindACourseService).to receive(:new).and_return(find_a_course_service)

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Apply filters')

    expect(page).to have_text(/Creative Maths/)
  end

  scenario 'Users can find training courses near them when they visit the page for the first time' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    find_a_course_service = instance_double(
      FindACourseService,
      search: find_a_course_search_response
    )
    allow(FindACourseService).to receive(:new).and_return(find_a_course_service)

    capture_user_location('NW6 8ET')
    visit(courses_path(topic_id: 'maths'))

    expect(page).to have_text(/Creative Maths/)
  end

  scenario 'Users can see the course details of a course' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    find_a_course_service = instance_double(
      FindACourseService,
      search: {
        'total' => 1,
        'results' => [{ 'courseName' => 'My Course', 'courseId' => '123', 'courseRunId' => '456' }]
      },
      details: {
        'courseName' => 'My Course', 'provider' => { 'postcode' => 'NW11 8QE' }
      }
    )
    allow(FindACourseService).to receive(:new).and_return(find_a_course_service)

    capture_user_location('NW6 8ET')
    visit(courses_path(topic_id: 'maths'))

    click_on('My Course')

    expect(page).to have_content('My Course')
  end

  scenario 'Users can update their session postcode if there was none there' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )
    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Apply filters')
    visit(courses_path(topic_id: 'maths'))

    expect(find_field('postcode').value).to eq 'NW6 8ET'
  end

  scenario 'Users can update their session postcode if it already existed' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )
    capture_user_location('NW6 1JF')
    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Apply filters')
    visit(courses_path(topic_id: 'maths'))

    expect(find_field('postcode').value).to eq 'NW6 8ET'
  end

  scenario 'Users see distance 20 miles selected by default' do
    capture_user_location('NW6 1JF')
    visit(courses_path(topic_id: 'maths'))

    expect(page).to have_select('distance', selected: 'Up to 20 miles')
  end

  scenario 'Users see course hours all selected by default' do
    capture_user_location('NW6 1JF')
    visit(courses_path(topic_id: 'maths'))

    expect(page).to have_select('hours', selected: 'All')
  end

  scenario 'Users see course type all selected by default' do
    capture_user_location('NW6 1JF')
    visit(courses_path(topic_id: 'maths'))

    expect(page).to have_select('delivery_type', selected: 'All')
  end

  scenario 'Users see selected distance filter when returning results' do
    capture_user_location('NW6 1JF')
    visit(courses_path(topic_id: 'maths'))
    select('Up to 40 miles', from: 'distance')
    click_on('Apply filters')

    expect(page).to have_select('distance', selected: 'Up to 40 miles')
  end

  scenario 'Selected distance gets remembered on user return' do
    find_a_course_service = instance_double(
      FindACourseService,
      search: {
        'total' => 1,
        'results' => [{ 'courseName' => 'My Course', 'courseId' => '123', 'courseRunId' => '456' }]
      },
      details: {
        'courseName' => 'My Course', 'provider' => { 'postcode' => 'NW11 8QE' }
      }
    )

    allow(FindACourseService).to receive(:new).and_return(find_a_course_service)

    capture_user_location('NW6 1JF')
    visit(courses_path(topic_id: 'maths'))
    select('Up to 40 miles', from: 'distance')
    click_on('Apply filters')
    click_on('My Course')
    click_on('Courses near you')

    expect(page).to have_select('distance', selected: 'Up to 40 miles')
  end

  scenario 'Users see selected course hour filter when returning results' do
    capture_user_location('NW6 1JF')
    visit(courses_path(topic_id: 'maths'))
    select('Flexible', from: 'hours')
    click_on('Apply filters')

    expect(page).to have_select('hours', selected: 'Flexible')
  end

  scenario 'Users see selected course type filter when returning results' do
    capture_user_location('NW6 1JF')
    visit(courses_path(topic_id: 'maths'))
    select('Online', from: 'delivery_type')
    click_on('Apply filters')

    expect(page).to have_select('delivery_type', selected: 'Online')
  end

  scenario 'User can see relevant courses from selecting multiple filters' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    find_a_course_service = instance_double(
      FindACourseService,
      search: find_a_course_search_response
    )
    allow(FindACourseService).to receive(:new).and_return(find_a_course_service)

    capture_user_location('NW6 8ET')
    visit(courses_path(topic_id: 'maths'))
    select('Up to 40 miles', from: 'distance')
    select('Online', from: 'delivery_type')
    select('Flexible', from: 'hours')

    click_on('Apply filters')

    expect(page).to have_text(/Mathematics Level 2/)
  end

  scenario 'Pagination not visible if results number < 10' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    find_a_course_service = instance_double(
      FindACourseService,
      search: {
        'total' => 3,
        'results' => (1..3).map {
          { 'courseName' => 'Course', 'courseId' => '123', 'courseRunId' => '456' }
        }
      }
    )
    allow(FindACourseService).to receive(:new).and_return(find_a_course_service)

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Apply filters')

    expect(page).not_to have_selector('nav.pagination')
  end

  scenario 'Pagination nav visible if results number > 10' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    find_a_course_service = instance_double(
      FindACourseService,
      search: {
        'total' => 52,
        'results' => (1..52).map {
          { 'courseName' => 'Course', 'courseId' => '123', 'courseRunId' => '456' }
        }
      }
    )
    allow(FindACourseService).to receive(:new).and_return(find_a_course_service)

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')

    click_on('Apply filters')
    click_on('6')

    expect(page).to have_selector('ul.govuk-list li', count: 2)
  end

  scenario 'User does not see distance if not available on course' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    find_a_course_service = instance_double(
      FindACourseService,
      search: {
        'total' => 1,
        'results' => [
          { 'courseName' => 'Course', 'courseId' => '123', 'courseRunId' => '456' }
        ]
      }
    )
    allow(FindACourseService).to receive(:new).and_return(find_a_course_service)

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')

    click_on('Apply filters')

    expect(page).not_to have_text('Distance:')
  end

  scenario 'User does not see course hours if marked as undefined on course' do
    find_a_course_service = instance_double(
      FindACourseService,
      search: {
        'total' => 1,
        'results' => [
          { 'courseName' => 'My Course', 'courseId' => '123', 'courseRunId' => '456', 'venueStudyModeDescription' => 'Undefined' }
        ]
      }
    )

    allow(FindACourseService).to receive(:new).and_return(find_a_course_service)

    capture_user_location('NW6 1JF')
    visit(courses_path(topic_id: 'maths'))

    expect(page).not_to have_text('Course hours:')
  end

  scenario 'User gets relevant messaging if their address is not valid' do
    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8E')
    click_on('Apply filters')

    expect(page).to have_text(/Enter a valid postcode/)
  end

  scenario 'User gets relevant messaging if their address is valid but not real' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [] }]
    )

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Apply filters')

    expect(page).to have_text(/Enter a real postcode/)
  end

  scenario 'User gets relevant messaging if their address coordinates could not be retrieved' do
    allow(Geocoder).to receive(:coordinates).and_raise(Geocoder::ServiceUnavailable)

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Apply filters')

    expect(page).to have_text(/Sorry, there is a problem with this service/)
  end

  scenario 'User gets relevant messaging if no address is entered' do
    visit(courses_path(topic_id: 'maths'))
    click_on('Apply filters')

    expect(page).to have_text(/Enter a postcode/)
  end

  scenario 'Error summary message present if no address is entered' do
    visit(courses_path(topic_id: 'maths'))
    click_on('Apply filters')

    expect(page).to have_content('There is a problem')
  end

  scenario 'Error summary contains error if no address is entered' do
    visit(courses_path(topic_id: 'maths'))
    click_on('Apply filters')

    expect(page.all('ul.govuk-error-summary__list li a').collect(&:text)).to eq(
      [
        'Enter a postcode'
      ]
    )
  end

  scenario 'tracks the outcode of the searched postcode' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Apply filters')

    expect(tracking_service).to have_received(:track_events).with(
      props:
      [
        {
          key: :courses_index_search,
          label: 'Courses near me - Postcode search',
          value: 'NW6'
        }
      ]
    )
  end

  scenario 'tracks course hours filter' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    select('Flexible', from: 'hours')
    click_on('Apply filters')

    expect(tracking_service).to have_received(:track_events).with(
      props:
      [
        {
          key: :filter_courses,
          label: 'Course hours',
          value: 'Flexible'
        }
      ]
    )
  end

  scenario 'does not track course hours filter when all selected' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Apply filters')

    expect(tracking_service).not_to have_received(:track_events).with(
      props:
      [
        {
          key: :filter_courses,
          label: 'Course hours',
          value: 'All'
        }
      ]
    )
  end

  scenario 'tracks course type filter' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    select('Classroom based', from: 'delivery_type')
    click_on('Apply filters')

    expect(tracking_service).to have_received(:track_events).with(
      props:
      [
        {
          key: :filter_courses,
          label: 'Course type',
          value: 'Classroom based'
        }
      ]
    )
  end

  scenario 'does not track course type filter when all selected' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Apply filters')

    expect(tracking_service).not_to have_received(:track_events).with(
      props:
      [
        {
          key: :filter_courses,
          label: 'Course type',
          value: 'All'
        }
      ]
    )
  end

  scenario 'when TrackingService errors, user journey is not affected' do
    tracking_service = instance_double(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)
    allow(tracking_service).to receive(:track_events).and_raise(TrackingService::TrackingServiceError)

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Apply filters')

    expect(page).to have_text('Maths courses near me')
  end

  scenario 'Breadcrumb links back to action plan' do
    visit(courses_path(topic_id: 'maths'))

    expect(page).to have_css('nav.govuk-breadcrumbs', text: 'Action plan')
  end

  scenario 'User gets relevant messaging if there is an API error' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )
    find_a_course_service = instance_double(FindACourseService)
    allow(FindACourseService).to receive(:new).and_return(find_a_course_service)
    allow(find_a_course_service).to receive(:search).and_raise(FindACourseService::APIError)

    capture_user_location('NW6 8ET')
    visit(courses_path(topic_id: 'maths'))

    expect(page).to have_text(/Sorry, there is a problem with this service/)
  end

  scenario 'User gets postcode validation error if there is a PostcodeNotFound Error from the API' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )
    find_a_course_service = instance_double(FindACourseService)
    allow(FindACourseService).to receive(:new).and_return(find_a_course_service)
    allow(find_a_course_service).to receive(:search).and_raise(FindACourseService::PostcodeNotFoundError)

    capture_user_location('NW6 8ET')
    visit(courses_path(topic_id: 'maths'))

    expect(page).to have_text(/Enter a real postcode/)
  end

  scenario 'User deep linking to a course details page gets relevant messaging if there is an API error' do
    find_a_course_service = instance_double(FindACourseService)
    allow(FindACourseService).to receive(:new).and_return(find_a_course_service)
    allow(find_a_course_service).to receive(:details).and_raise(FindACourseService::APIError)

    capture_user_location('NW6 8ET')
    visit(course_details_path(topic_id: 'maths', course_id: '111-11', course_run_id: '222-2'))

    expect(page).to have_text(/Sorry, there is a problem with this service/)
  end

  private

  def capture_user_location(postcode)
    visit(your_information_path)
    fill_in('user_personal_data[first_name]', with: 'John')
    fill_in('user_personal_data[last_name]', with: 'Mayer')
    fill_in('user_personal_data[postcode]', with: postcode)
    fill_in('user_personal_data[birth_day]', with: '1')
    fill_in('user_personal_data[birth_month]', with: '1')
    fill_in('user_personal_data[birth_year]', with: DateTime.now.year - 20)
    choose('user_personal_data[gender]', option: 'male')

    click_on('Continue')
  end
end
