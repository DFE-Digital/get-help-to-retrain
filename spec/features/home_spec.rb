require 'rails_helper'

RSpec.feature 'Navigation from home page' do
  scenario 'PID - absent from session - user gets redirected to your information page' do
    visit(root_path)

    click_on('Start now')

    expect(page).to have_current_path(your_information_path)
  end

  scenario 'PID - present on the session - user gets redirected to task-list page' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    create(:course, latitude: 0.1, longitude: 1.001, topic: 'maths')

    visit(your_information_path)

    fill_in('user_personal_data[first_name]', with: 'John')
    fill_in('user_personal_data[last_name]', with: 'Mayer')
    fill_in('user_personal_data[postcode]', with: 'NW6 1JJ')
    fill_in('user_personal_data[birth_day]', with: '1')
    fill_in('user_personal_data[birth_month]', with: '1')
    fill_in('user_personal_data[birth_year]', with: DateTime.now.year - 20)
    choose('user_personal_data[gender]', option: 'male')

    click_on('Continue')

    visit(root_path)

    click_on('Start now')

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'User can access the cookies policy page from the cookies modal', :js do
    visit(root_path)

    click_on('Cookie settings')

    expect(page).to have_text('Cookies are used')
  end

  scenario 'User can access the cookies policy page from the footer' do
    visit(root_path)

    click_on('Cookies')

    expect(page).to have_text('Cookies are used')
  end

  scenario 'User can access the privacy policy page from the footer' do
    visit(root_path)

    click_on('Privacy')

    expect(page).to have_text('Privacy policy')
  end
end
