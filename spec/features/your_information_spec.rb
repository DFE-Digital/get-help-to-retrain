require 'rails_helper'

RSpec.feature 'Your information' do
  let(:i18n_scope) {
    'activerecord.errors.models.user_personal_data.attributes'
  }

  let(:dob_invalid_error) {
    I18n.t('dob.invalid', scope: i18n_scope)
  }

  let(:dob_blank_error) {
    I18n.t('dob.blank', scope: i18n_scope)
  }

  let(:dob_past_error) {
    I18n.t('dob.past', scope: i18n_scope)
  }

  let(:dob_missing_year_error) {
    I18n.t('dob.missing_year', scope: i18n_scope)
  }

  let(:dob_missing_day_error) {
    I18n.t('dob.missing_day', scope: i18n_scope)
  }

  let(:dob_missing_month_error) {
    I18n.t('dob.missing_month', scope: i18n_scope)
  }

  let(:dob_missing_month_year_error) {
    I18n.t('dob.missing_month_year', scope: i18n_scope)
  }

  let(:dob_missing_day_month_error) {
    I18n.t('dob.missing_day_month', scope: i18n_scope)
  }

  let(:dob_missing_day_year_error) {
    I18n.t('dob.missing_day_year', scope: i18n_scope)
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
    fill_in_user_information_form
    click_on('Continue')

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'User can access the privacy policy page' do
    click_on('privacy policy')

    expect(page).to have_text('Privacy policy')
  end

  scenario 'Postcode entered by user is tracked' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    fill_in_user_information_form
    click_on('Continue')

    expect(tracking_service).to have_received(:track_events).with(
      props:
      [
        {
          key: :pages_location_eligibility_search,
          label: 'Your location - Postcode search',
          value: 'NW6 1JJ'
        }
      ]
    )
  end

  scenario 'when TrackingService errors, user journey is not affected' do
    tracking_service = instance_double(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)
    allow(tracking_service).to receive(:track_events).and_raise(TrackingService::TrackingServiceError)

    fill_in_user_information_form
    click_on('Continue')

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'Error summary message present when there is an error in the page' do
    click_on('Continue')

    expect(page).to have_content('There is a problem')
  end

  scenario 'Error summary contains list of all errors on the page' do
    fill_in('user_personal_data[postcode]', with: 'NW6 1JJ')
    click_on('Continue')

    expect(page.all('ul.govuk-error-summary__list li a').collect(&:text)).to eq(
      [
        first_name_blank_error,
        last_name_blank_error,
        dob_blank_error,
        gender_blank_error
      ]
    )
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

  scenario 'When the date of birth is empty user gets: Enter your date of birth' do
    click_on('Continue')

    expect(page).to have_content(dob_blank_error)
  end

  scenario 'When the day of birth is missing user gets: Enter your date of birth' do
    fill_in('user_personal_data[birth_month]', with: '1')
    fill_in('user_personal_data[birth_year]', with: DateTime.now.year - 18)

    click_on('Continue')

    expect(page).to have_content(dob_missing_day_error)
  end

  scenario 'When the month of birth is missing user gets: Your date of birth must include a month' do
    fill_in('user_personal_data[birth_day]', with: '1')
    fill_in('user_personal_data[birth_year]', with: DateTime.now.year - 18)

    click_on('Continue')

    expect(page).to have_content(dob_missing_month_error)
  end

  scenario 'When the year of birth is missing user gets: Your date of birth must include a year' do
    fill_in('user_personal_data[birth_day]', with: '1')
    fill_in('user_personal_data[birth_month]', with: '1')

    click_on('Continue')

    expect(page).to have_content(dob_missing_year_error)
  end

  scenario 'When the day and month of birth are missing user gets: Your date of birth must include a day and month' do
    fill_in('user_personal_data[birth_year]', with: DateTime.now.year - 18)

    click_on('Continue')

    expect(page).to have_content(dob_missing_day_month_error)
  end

  scenario 'When the month and year of birth are missing user gets: Your date of birth must include a month and year' do
    fill_in('user_personal_data[birth_day]', with: '1')

    click_on('Continue')

    expect(page).to have_content(dob_missing_month_year_error)
  end

  scenario 'When the day and year of birth are missing user gets: Your date of birth must include a day and year' do
    fill_in('user_personal_data[birth_month]', with: '1')

    click_on('Continue')

    expect(page).to have_content(dob_missing_day_year_error)
  end

  scenario 'When the date is valid but in future user gets: Your date of birth must be in the past' do
    fill_in('user_personal_data[birth_day]', with: '1')
    fill_in('user_personal_data[birth_month]', with: '1')
    fill_in('user_personal_data[birth_year]', with: DateTime.now.year + 3)

    click_on('Continue')

    expect(page).to have_content(dob_past_error)
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

  scenario 'When the date is present but has invalid year, user gets: Your date of birth must include a year' do
    fill_in('user_personal_data[birth_day]', with: '1')
    fill_in('user_personal_data[birth_month]', with: '1')
    fill_in('user_personal_data[birth_year]', with: '-34')

    click_on('Continue')

    expect(page).to have_content(dob_missing_year_error)
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
