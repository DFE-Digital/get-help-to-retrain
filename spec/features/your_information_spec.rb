require 'rails_helper'

RSpec.feature 'Your information' do
  let(:i18n_scope) {
    'activerecord.errors.models.user_personal_data.attributes'
  }

  let(:dob_invalid_error) {
    I18n.t('dob.invalid', scope: i18n_scope)
  }

  let(:first_name_blank_error) {
    I18n.t('first_name.blank', scope: i18n_scope)
  }

  let(:last_name_blank_error) {
    I18n.t('last_name.blank', scope: i18n_scope)
  }

  let(:postcode_invalid_error) {
    I18n.t('courses.invalid_postcode_error')
  }

  let(:gender_blank_error) {
    I18n.t('gender.blank', scope: i18n_scope)
  }

  background do
    visit(your_information_path)
  end

  scenario 'When user fills the form correctly one gets taken to tasks-list page' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 1JJ', [{ 'coordinates' => [0.1, 1] }]
    )
    create(:course, latitude: 0.1, longitude: 1, topic: 'maths')

    fill_in_user_information_form
    click_on('Continue')

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'When form valid and no courses are available one gets taken to location ineligible page' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 1JJ', [{ 'coordinates' => [0.1, 1] }]
    )
    create(:course, latitude: 0.2, longitude: 2, topic: 'maths')

    fill_in_user_information_form
    click_on('Continue')

    expect(page).to have_current_path(location_ineligible_path)
  end

  scenario 'User can proceed to your information if postcode is not eligible' do
    visit(location_ineligible_path)
    click_on('Continue')

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'User is redirected to error page if their postcode coordinates could not be retrieved' do
    allow(Geocoder).to receive(:coordinates).and_raise(Geocoder::ServiceUnavailable)

    fill_in_user_information_form
    click_on('Continue')

    expect(page).to have_text(/Sorry, there is a problem with this service/)
  end

  scenario 'User can continue to task list even if postcode service is down' do
    visit(postcode_search_error_path)
    click_on('Continue')

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'User can access the privacy policy page' do
    click_on('privacy policy')

    expect(page).to have_text('Privacy policy')
  end

  scenario 'Postcode entered by user is tracked' do
    allow(TrackingService).to receive(:track_event)

    fill_in_user_information_form
    click_on('Continue')

    expect(TrackingService).to have_received(:track_event).with('Your location - Postcode search', search: 'NW6 1JJ')
  end

  scenario 'Error message present when first name is missing' do
    click_on('Continue')

    expect(page).to have_content(first_name_blank_error)
  end

  scenario 'First name input field is highlighted when there is a validation error' do
    click_on('Continue')

    expect(page).to have_css('input#user_personal_data_first_name', class: 'govuk-input--error')
  end

  scenario 'Error message present when last name is missing' do
    click_on('Continue')

    expect(page).to have_content(last_name_blank_error)
  end

  scenario 'Last name input field is highlighted when there is a validation error' do
    click_on('Continue')

    expect(page).to have_css('input#user_personal_data_last_name', class: 'govuk-input--error')
  end

  scenario 'When postcode is missing users get: Enter a postcode' do
    click_on('Continue')

    expect(page).to have_content('Enter a postcode')
  end

  scenario 'When postcode is invalid users get: Enter a valid postcode' do
    fill_in('user_personal_data[postcode]', with: 'INVALID CODE')
    click_on('Continue')

    expect(page).to have_content(postcode_invalid_error)
  end

  scenario 'Postcode input field is highlighted when there is a validation error' do
    click_on('Continue')

    expect(page).to have_css('input#user_personal_data_postcode', class: 'govuk-input--error')
  end

  scenario 'When the date of birth is empty user gets: Enter a valid date of birth' do
    click_on('Continue')

    expect(page).to have_content(dob_invalid_error)
  end

  scenario 'When the date is valid but in future user gets: Enter a valid date of birth' do
    fill_in('user_personal_data[birth_day]', with: '1')
    fill_in('user_personal_data[birth_month]', with: '1')
    fill_in('user_personal_data[birth_year]', with: DateTime.now.year + 3)

    click_on('Continue')

    expect(page).to have_content(dob_invalid_error)
  end

  scenario 'When the date is present but has invalid day, user gets: Enter a valid date of birth' do
    fill_in('user_personal_data[birth_day]', with: '99')
    fill_in('user_personal_data[birth_month]', with: '1')
    fill_in('user_personal_data[birth_year]', with: DateTime.now.year - 20)

    click_on('Continue')

    expect(page).to have_content(dob_invalid_error)
  end

  scenario 'When the date is present but has invalid month, user gets: Enter a valid date of birth' do
    fill_in('user_personal_data[birth_day]', with: '1')
    fill_in('user_personal_data[birth_month]', with: '99')
    fill_in('user_personal_data[birth_year]', with: DateTime.now.year - 20)

    click_on('Continue')

    expect(page).to have_content(dob_invalid_error)
  end

  scenario 'When the date is present but has invalid year, user gets: Enter a valid date of birth' do
    fill_in('user_personal_data[birth_day]', with: '1')
    fill_in('user_personal_data[birth_month]', with: '1')
    fill_in('user_personal_data[birth_year]', with: '99999')

    click_on('Continue')

    expect(page).to have_content(dob_invalid_error)
  end

  scenario 'Birth day field is highlighted when there is a validation error' do
    click_on('Continue')

    expect(page).to have_css('input#user_personal_data_birth_day', class: 'govuk-input--error')
  end

  scenario 'Birth month field is highlighted when there is a validation error' do
    click_on('Continue')

    expect(page).to have_css('input#user_personal_data_birth_month', class: 'govuk-input--error')
  end

  scenario 'Birth year field is highlighted when there is a validation error' do
    click_on('Continue')

    expect(page).to have_css('input#user_personal_data_birth_year', class: 'govuk-input--error')
  end

  scenario 'When no gender is selected users get the error validation message' do
    click_on('Continue')

    expect(page).to have_content(gender_blank_error)
  end

  scenario 'breadcrumbs navigate back to home page' do
    click_on('Home')

    expect(page).to have_current_path(root_path)
  end

  scenario 'Redirects to task-list page if the information has already been submitted' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 1JJ', [{ 'coordinates' => [0.1, 1] }]
    )
    create(:course, latitude: 0.1, longitude: 1, topic: 'maths')

    fill_in_user_information_form
    click_on('Continue')

    visit(your_information_path)

    expect(page).to have_current_path(task_list_path)
  end

  def fill_in_user_information_form
    fill_in('user_personal_data[first_name]', with: 'John')
    fill_in('user_personal_data[last_name]', with: 'Mayer')
    fill_in('user_personal_data[postcode]', with: 'NW6 1JJ')
    fill_in('user_personal_data[birth_day]', with: '1')
    fill_in('user_personal_data[birth_month]', with: '1')
    fill_in('user_personal_data[birth_year]', with: DateTime.now.year - 20)
    choose('user_personal_data[gender]', option: 'male')
  end
end
