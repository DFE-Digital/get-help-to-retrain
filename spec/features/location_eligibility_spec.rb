require 'rails_helper'

RSpec.feature 'Check your location is eligible', type: :feature do
  scenario 'User is taken to location eligiblity page from start page' do
    visit(root_path)
    click_on('Start now')

    expect(page).to have_current_path(location_eligibility_path)
  end

  scenario 'User is taken to location ineligible page if postcode is not eligible' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    create(:course, latitude: 0.2, longitude: 2, topic: 'maths')

    visit(location_eligibility_path)
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Continue')

    expect(page).to have_current_path(location_ineligible_path)
  end

  scenario 'User can proceed to your information if postcode is not eligible' do
    visit(location_ineligible_path)
    click_on('Continue')

    expect(page).to have_current_path(your_information_path)
  end

  scenario 'User skips eligibilty page straight to your information page if the postcode is already stored on the session' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    create(:course, latitude: 0.1, longitude: 1.001, topic: 'maths')

    visit(location_eligibility_path)
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Continue')

    visit(location_eligibility_path)

    expect(page).to have_current_path(your_information_path)
  end

  scenario 'User follows through to user information page if postcode eligible' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    create(:course, latitude: 0.1, longitude: 1.001, topic: 'maths')

    visit(location_eligibility_path)
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Continue')

    expect(page).to have_current_path(your_information_path)
  end

  scenario 'User gets relevant messaging if their address is not valid' do
    visit(location_eligibility_path)
    fill_in('postcode', with: 'NW6 8E')
    click_on('Continue')

    expect(page).to have_text(/Enter a valid postcode/)
  end

  scenario 'User gets relevant messaging if their address is valid but not real' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [] }]
    )

    visit(location_eligibility_path)
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Continue')

    expect(page).to have_text(/Enter a real postcode/)
  end

  scenario 'User is redirected to error page if their postcode coordinates could not be retrieved' do
    allow(Geocoder).to receive(:coordinates).and_raise(Geocoder::ServiceUnavailable)

    visit(location_eligibility_path)
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Continue')

    expect(page).to have_text(/Sorry, there is a problem with this service/)
  end

  scenario 'User can continue to task list even if postcode service is down' do
    visit(postcode_search_error_path)
    click_on('Continue')

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'User gets relevant messaging if no address is entered' do
    visit(location_eligibility_path)
    click_on('Continue')

    expect(page).to have_text(/Enter a postcode/)
  end

  scenario 'tracks search postcode' do
    allow(TrackingService).to receive(:track_event)

    visit(location_eligibility_path)
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Continue')

    expect(TrackingService).to have_received(:track_event).with('Your location - Postcode search', search: 'NW6 8ET')
  end
end
