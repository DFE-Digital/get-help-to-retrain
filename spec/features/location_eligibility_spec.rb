require 'rails_helper'

RSpec.feature 'Check your location is eligible', type: :feature do
  background do
    enable_feature! :location_eligibility
  end

  scenario 'User is taken to location eligiblity page from start page' do
    visit(root_path)
    click_on('Start now')

    expect(page).to have_current_path(location_eligibility_path)
  end

  scenario 'User is taken back to start page if postcode is not eligible' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    create(:course, latitude: 0.2, longitude: 2, topic: 'maths')

    visit(location_eligibility_path)
    fill_in('postcode', with: 'NW6 8ET')
    find('.govuk-button').click

    expect(page).to have_current_path(root_path)
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

  scenario 'User gets relevant messaging if their address is not valid' do
    visit(location_eligibility_path)
    fill_in('postcode', with: 'NW6 8E')
    find('.govuk-button').click

    expect(page).to have_text(/Enter a valid postcode/)
  end

  scenario 'User gets relevant messaging if their address is valid but not real' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => nil }]
    )

    visit(location_eligibility_path)
    fill_in('postcode', with: 'NW6 8ET')
    find('.govuk-button').click

    expect(page).to have_text(/Enter a real postcode/)
  end

  xscenario 'User gets relevant messaging if their address coordinates could not be retrieved' do
    allow(Geocoder).to receive(:coordinates).and_raise(Geocoder::ServiceUnavailable)

    visit(location_eligibility_path)
    fill_in('postcode', with: 'NW6 8ET')
    find('.govuk-button').click

    expect(page).to have_text(/We cannot verify your postcode/)
  end

  scenario 'search form required field available when no js running' do
    visit(location_eligibility_path)

    expect(page).to have_selector('#postcode[required]')
  end

  scenario 'search form required field disabled by default', :js do
    visit(location_eligibility_path)

    expect(page).not_to have_selector('#postcode[required]')
  end

  context 'when feature disabled' do
    background do
      disable_feature! :location_eligibility
    end

    scenario 'User is taken to task list page from start page' do
      create(:course, latitude: 0.1, longitude: 1, topic: 'maths')

      visit(root_path)
      click_on('Start now')
      expect(page).to have_current_path(task_list_path)
    end
  end
end
