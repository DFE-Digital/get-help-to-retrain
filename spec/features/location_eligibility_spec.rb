require 'rails_helper'

RSpec.feature 'Check your location is eligible', type: :feature do
  background do
    disable_feature! :user_personal_data
  end

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
    find('.govuk-button').click

    expect(page).to have_current_path(location_ineligible_path)
  end

  scenario 'User can proceed to tasklist if postcode is not eligible' do
    visit(location_ineligible_path)
    find('.govuk-button').click

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'User can will proceed to your information even if postcode is not eligible' do
    enable_feature! :user_personal_data

    visit(location_ineligible_path)
    find('.govuk-button').click

    expect(page).to have_current_path(your_information_path)
  end

  scenario 'User follows through to task list page if postcode eligible' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    create(:course, latitude: 0.1, longitude: 1.001, topic: 'maths')

    visit(location_eligibility_path)
    fill_in('postcode', with: 'NW6 8ET')
    find('.govuk-button').click

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'User follows through to your information page if postcode eligible and feature is on' do
    enable_feature! :user_personal_data

    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    create(:course, latitude: 0.1, longitude: 1.001, topic: 'maths')

    visit(location_eligibility_path)
    fill_in('postcode', with: 'NW6 8ET')
    find('.govuk-button').click

    expect(page).to have_current_path(your_information_path)
  end

  scenario 'User gets relevant messaging if their address is not valid' do
    visit(location_eligibility_path)
    fill_in('postcode', with: 'NW6 8E')
    find('.govuk-button').click

    expect(page).to have_text(/Enter a valid postcode/)
  end

  scenario 'User gets relevant messaging if their address is valid but not real' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [] }]
    )

    visit(location_eligibility_path)
    fill_in('postcode', with: 'NW6 8ET')
    find('.govuk-button').click

    expect(page).to have_text(/Enter a real postcode/)
  end

  scenario 'User is redirected to error page if their postcode coordinates could not be retrieved' do
    allow(Geocoder).to receive(:coordinates).and_raise(Geocoder::ServiceUnavailable)

    visit(location_eligibility_path)
    fill_in('postcode', with: 'NW6 8ET')
    find('.govuk-button').click

    expect(page).to have_text(/Sorry, there is a problem with this service/)
  end

  scenario 'User can continue to task list even if postcode service is down' do
    visit(postcode_search_error_path)
    find('.govuk-button').click

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'User gets relevant messaging if no address is entered' do
    visit(location_eligibility_path)
    find('.govuk-button').click

    expect(page).to have_text(/Enter a postcode/)
  end
end
