require 'rails_helper'

RSpec.feature 'Find training courses', type: :feature do
  scenario 'User cannot see a list of all training courses for a topic without postcode' do
    create_list(:course, 2, topic: 'maths')
    visit(courses_path(topic_id: 'maths'))

    expect(page).to have_text('0 courses found')
  end

  scenario 'The postcode is persisted on Maths courses page when user comes from training hub page' do
    capture_user_location('NW6 1JF')

    visit(training_hub_path)

    click_on('Find a maths course')

    expect(find_field('postcode').value).to eq 'NW6 1JF'
  end

  scenario 'The postcode is persisted on English courses page when user comes from training hub page' do
    capture_user_location('NW6 1JF')

    visit(training_hub_path)

    click_on('Find an English course')

    expect(find_field('postcode').value).to eq 'NW6 1JF'
  end

  scenario 'The postcode is persisted on maths courses page when user comes from math course overview page' do
    capture_user_location('NW6 1JF')

    visit(maths_course_overview_path)

    click_on('Find a maths course')

    expect(find_field('postcode').value).to eq 'NW6 1JF'
  end

  scenario 'The postcode is persisted on english courses page when user comes from an english course overview page' do
    capture_user_location('NW6 1JF')

    visit(english_course_overview_path)

    click_on('Find an English course')

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
    visit(location_eligibility_path)
    fill_in('postcode', with: postcode)
    click_on('Continue')
  end
end
