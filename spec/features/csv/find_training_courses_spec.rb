require 'rails_helper'

RSpec.feature 'Find training courses', type: :feature do
  before do
    enable_feature!(:csv_courses)
  end

  scenario 'User cannot see a list of all training courses for a topic without postcode' do
    create_list(:course_lookup, 2, subject: 'maths')
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

    course_lookup = create(:course_lookup, latitude: 0.1, longitude: 1.001, subject: 'maths')
    create(:course_lookup, latitude: 0.1, longitude: 2, subject: 'maths')
    create(:course_lookup, latitude: 0.1, longitude: 3, subject: 'maths')

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Apply filters')

    expect(page).to have_text(course_lookup.course.name)
  end

  scenario 'Users can find training courses near them when they visit the page' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )
    course_lookup = create(:course_lookup, latitude: 0.1, longitude: 1.001, subject: 'maths')
    create(:course_lookup, latitude: 0.1, longitude: 2, subject: 'maths')
    create(:course_lookup, latitude: 0.1, longitude: 3, subject: 'maths')

    capture_user_location('NW6 8ET')
    visit(courses_path(topic_id: 'maths'))

    expect(page).to have_text(course_lookup.course.name)
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

  scenario 'User can find results for certain distance' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )
    course_lookup = create(:course_lookup, latitude: 0.1, longitude: 1.5, subject: 'maths')
    capture_user_location('NW6 8ET')
    visit(courses_path(topic_id: 'maths'))
    select('Up to 40 miles', from: 'distance')
    click_on('Apply filters')

    expect(page).to have_text(course_lookup.course.name)
  end

  scenario 'User does not see unselected distances' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )
    course_lookup = create(:course_lookup, latitude: 0.1, longitude: 1.5, subject: 'maths')
    capture_user_location('NW6 8ET')
    visit(courses_path(topic_id: 'maths'))
    select('Up to 10 miles', from: 'distance')
    click_on('Apply filters')

    expect(page).not_to have_text(course_lookup.course.name)
  end

  scenario 'User can find results for certain hours' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    course_lookup = create(
      :course_lookup,
      latitude: 0.1,
      longitude: 1,
      subject: 'maths',
      hours: 'Flexible'
    )
    capture_user_location('NW6 8ET')
    visit(courses_path(topic_id: 'maths'))
    select('Flexible', from: 'hours')
    click_on('Apply filters')

    expect(page).to have_text(course_lookup.course.name)
  end

  scenario 'User does not see unselected hours' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )
    course_lookup = create(
      :course_lookup,
      latitude: 0.1,
      longitude: 1,
      subject: 'maths',
      hours: 'Part time'
    )
    capture_user_location('NW6 8ET')
    visit(courses_path(topic_id: 'maths'))
    select('Flexible', from: 'hours')
    click_on('Apply filters')

    expect(page).not_to have_text(course_lookup.course.name)
  end

  scenario 'User can find results for certain delivery types' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )
    course_lookup = create(
      :course_lookup,
      latitude: 0.1,
      longitude: 1,
      subject: 'maths',
      delivery_type: 'Online'
    )
    capture_user_location('NW6 8ET')
    visit(courses_path(topic_id: 'maths'))
    select('Online', from: 'delivery_type')
    click_on('Apply filters')

    expect(page).to have_text(course_lookup.course.name)
  end

  scenario 'User does not see unselected delivery types' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )
    course_lookup = create(
      :course_lookup,
      latitude: 0.1,
      longitude: 1,
      subject: 'maths',
      delivery_type: 'Work based'
    )
    capture_user_location('NW6 8ET')
    visit(courses_path(topic_id: 'maths'))
    select('Online', from: 'delivery_type')
    click_on('Apply filters')

    expect(page).not_to have_text(course_lookup.course.name)
  end

  scenario 'Pagination not visible if results number < 10' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    create(:course_lookup, latitude: 0.1, longitude: 1.001, subject: 'maths')

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Apply filters')

    expect(page).not_to have_selector('nav.pagination')
  end

  scenario 'Pagination nav visible if results number > 10' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    create_list(:course_lookup, 11, latitude: 0.1, longitude: 1.001, subject: 'maths')

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Apply filters')

    click_on('Next')

    expect(page).to have_selector('ul.govuk-list li', count: 1)
  end

  scenario 'User gets relevant messaging if their address is not valid' do
    create(:course_lookup, subject: 'maths')

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8E')
    click_on('Apply filters')

    expect(page).to have_text(/Enter a valid postcode/)
  end

  scenario 'User gets relevant messaging if their address is valid but not real' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [] }]
    )
    create(:course_lookup, subject: 'maths')

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Apply filters')

    expect(page).to have_text(/Enter a real postcode/)
  end

  scenario 'User gets relevant messaging if their address coordinates could not be retrieved' do
    allow(Geocoder).to receive(:coordinates).and_raise(Geocoder::ServiceUnavailable)
    create(:course_lookup, subject: 'maths')

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Apply filters')

    expect(page).to have_text(/Sorry, there is a problem with this service/)
  end

  scenario 'User gets relevant messaging if no address is entered' do
    create(:course_lookup, subject: 'maths')
    visit(courses_path(topic_id: 'maths'))
    click_on('Apply filters')

    expect(page).to have_text(/Enter a postcode/)
  end

  scenario 'Error summary message present if no address is entered' do
    create(:course_lookup, subject: 'maths')
    visit(courses_path(topic_id: 'maths'))
    click_on('Apply filters')

    expect(page).to have_content('There is a problem')
  end

  scenario 'Error summary contains error if no address is entered' do
    create(:course_lookup, subject: 'maths')
    visit(courses_path(topic_id: 'maths'))
    click_on('Apply filters')

    expect(page.all('ul.govuk-error-summary__list li a').collect(&:text)).to eq(
      [
        'Enter a postcode'
      ]
    )
  end

  scenario 'tracks search postcode' do
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
          value: 'NW6 8ET'
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
