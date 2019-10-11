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

  scenario 'The user can navigate to maths course page from training hub' do
    visit(training_hub_path)
    click_on('Find a maths course')

    expect(page).to have_current_path(courses_path('maths'))
  end

  scenario 'The user can navigate to english course page from training hub' do
    visit(training_hub_path)
    click_on('Find an English course')

    expect(page).to have_current_path(courses_path('english'))
  end

  scenario 'The user can navigate to english course page from math course overview page' do
    visit(maths_course_overview_path)
    click_on('Find a maths course')

    expect(page).to have_current_path(courses_path('maths'))
  end

  scenario 'The user can navigate to english course page from an english course overview page' do
    visit(english_course_overview_path)
    click_on('Find an English course')

    expect(page).to have_current_path(courses_path('english'))
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
    allow(TrackingService).to receive(:track_event)

    visit(courses_path(topic_id: 'maths'))
    fill_in('postcode', with: 'NW6 8ET')
    find('.search-button-results').click

    expect(TrackingService).to have_received(:track_event).with('Courses near me - Postcode search', search: 'NW6 8ET')
  end

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
