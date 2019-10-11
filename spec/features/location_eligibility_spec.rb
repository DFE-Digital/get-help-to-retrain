require 'rails_helper'

RSpec.feature 'Check your location is eligible', type: :feature do
  xscenario 'User is taken to location ineligible page if postcode is not eligible' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    create(:course, latitude: 0.2, longitude: 2, topic: 'maths')

    visit(your_information_path)
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Continue')

    expect(page).to have_current_path(location_ineligible_path)
  end

  scenario 'User can proceed to your information if postcode is not eligible' do
    visit(location_ineligible_path)
    click_on('Continue')

    expect(page).to have_current_path(your_information_path)
  end

  xscenario 'User is redirected to error page if their postcode coordinates could not be retrieved' do
    allow(Geocoder).to receive(:coordinates).and_raise(Geocoder::ServiceUnavailable)

    visit(your_information_path)
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Continue')

    expect(page).to have_text(/Sorry, there is a problem with this service/)
  end

  scenario 'User can continue to task list even if postcode service is down' do
    visit(postcode_search_error_path)
    click_on('Continue')

    expect(page).to have_current_path(task_list_path)
  end

  xscenario 'tracks search postcode' do
    allow(TrackingService).to receive(:track_event)

    visit(your_information_path)
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Continue')

    expect(TrackingService).to have_received(:track_event).with('Your location - Postcode search', search: 'NW6 8ET')
  end
end
