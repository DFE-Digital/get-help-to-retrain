require 'rails_helper'

RSpec.feature 'Find training courses', type: :feature do
  scenario 'User can see a list of all training courses for a topic' do
    create_list(:course, 2, topic: 'maths')
    visit(courses_path(topic_id: 'maths'))

    expect(page).to have_selector('ul.govuk-list li', count: 2)
  end

  scenario 'User can find training courses near them' do
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

    expect(page).to have_text(/Please enter a valid address/)
  end

  scenario 'search form required field available when no js running' do
    create(:course, topic: 'maths')
    visit(courses_path(topic_id: 'maths'))

    expect(page).to have_selector('#postcode[required]')
  end

  scenario 'search form required field disabled by default', :js do
    create(:course, topic: 'maths')
    visit(courses_path(topic_id: 'maths'))

    expect(page).not_to have_selector('#postcode[required]')
  end
end
