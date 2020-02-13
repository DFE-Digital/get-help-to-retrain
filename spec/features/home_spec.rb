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

  scenario 'User can access the information sources page from the footer' do
    visit(root_path)
    click_on('Information sources')

    expect(page).to have_text('Information sources')
  end

  scenario 'User defaults to going back to root path from information sources page' do
    visit(information_sources_path)
    click_on('Back')

    expect(page).to have_current_path(root_path)
  end

  scenario 'User can go back to previous page from information sources page' do
    visit(task_list_path)

    click_on('Information sources')
    click_on('Back')

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'User can access the accessibility statement page from the footer' do
    visit(root_path)
    click_on('Accessibility statement')

    expect(page).to have_text('Accessibility')
  end

  scenario 'User defaults to going back to root path from accessibility statement page' do
    visit(accessibility_statement_path)
    click_on('Back')

    expect(page).to have_current_path(root_path)
  end

  scenario 'User can go back to previous page from accessibility statement page' do
    visit(task_list_path)

    click_on('Accessibility statement')
    click_on('Back')

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'Sessions not created when user has no previous session' do
    visit(root_path)

    expect(Session.count).to be_zero
  end
end
