require 'rails_helper'

RSpec.feature 'Find training courses', type: :feature do
  scenario 'User cannot see a list of all training courses for a topic without postcode' do
    create_list(:course, 2, topic: 'maths')
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

    create(:course, latitude: 0.1, longitude: 1.001, topic: 'maths')
    create(:course, latitude: 0.1, longitude: 2, topic: 'maths')
    create(:course, latitude: 0.1, longitude: 3, topic: 'maths')

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    find('.search-button-results').click

    expect(page).to have_selector('ul.govuk-list li', count: 1)
  end

  scenario 'Users can update their session postcode if there was none there' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )
    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    find('.search-button-results').click
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
    find('.search-button-results').click
    visit(courses_path(topic_id: 'maths'))

    expect(find_field('postcode').value).to eq 'NW6 8ET'
  end

  scenario 'Pagination not visible if results number < 10' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    create(:course, latitude: 0.1, longitude: 1.001, topic: 'maths')

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    find('.search-button-results').click

    expect(page).not_to have_selector('nav.pagination')
  end

  scenario 'Pagination nav visible if results number > 10' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    create_list(:course, 11, latitude: 0.1, longitude: 1.001, topic: 'maths')

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    find('.search-button-results').click

    click_on('Next')

    expect(page).to have_selector('ul.govuk-list li', count: 1)
  end

  scenario 'User gets relevant messaging if their address is not valid' do
    create(:course, topic: 'maths')

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8E')
    find('.search-button-results').click

    expect(page).to have_text(/Enter a valid postcode/)
  end

  scenario 'User gets relevant messaging if their address is valid but not real' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [] }]
    )
    create(:course, topic: 'maths')

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    find('.search-button-results').click

    expect(page).to have_text(/Enter a real postcode/)
  end

  scenario 'User gets relevant messaging if their address coordinates could not be retrieved' do
    allow(Geocoder).to receive(:coordinates).and_raise(Geocoder::ServiceUnavailable)
    create(:course, topic: 'maths')

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    find('.search-button-results').click

    expect(page).to have_text(/Sorry, there is a problem with this service/)
  end

  scenario 'User gets relevant messaging if no address is entered' do
    create(:course, topic: 'maths')
    visit(courses_path(topic_id: 'maths'))
    find('.search-button-results').click

    expect(page).to have_text(/Enter a postcode/)
  end

  scenario 'tracks search postcode' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    find('.search-button-results').click

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
    find('.search-button-results').click

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
