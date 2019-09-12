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

  let(:gender_blank_error) {
    I18n.t('gender.blank', scope: i18n_scope)
  }

  background do
    enable_feature! :user_personal_data

    visit(your_information_path)
  end

  scenario 'When user fills the form correctly one gets taken to tasks-list page' do
    fill_in('user_personal_data[first_name]', with: 'John')
    fill_in('user_personal_data[last_name]', with: 'Mayer')
    fill_in('user_personal_data[postcode]', with: 'NW6 1JJ')
    fill_in('user_personal_data[birth_day]', with: '1')
    fill_in('user_personal_data[birth_month]', with: '1')
    fill_in('user_personal_data[birth_year]', with: DateTime.now.year - 20)
    choose('user_personal_data[gender]', option: 'male')

    click_on('Continue')

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'When user clicks Skip link one gets taken to tasks-list page' do
    click_on('Skip this step')

    expect(page).to have_current_path(task_list_path)
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

  scenario 'When postcode is missing users get: Invalid UK postcode' do
    fill_in('user_personal_data[postcode]', with: 'INVALID CODE')
    click_on('Continue')

    expect(page).to have_content('Invalid UK postcode')
  end

  scenario 'Postcode input field is highlighted when there is a validation error' do
    click_on('Continue')

    expect(page).to have_css('input#user_personal_data_postcode', class: 'govuk-input--error')
  end

  scenario 'Coming from the previous page postcode is persisted' do
    Geocoder::Lookup::Test.add_stub(
      'NW6 8ET', [{ 'coordinates' => [0.1, 1] }]
    )

    create(:course, latitude: 0.1, longitude: 1.001, topic: 'maths')

    visit(location_eligibility_path)
    fill_in('postcode', with: 'NW6 8ET')
    click_on('Continue')

    expect(find_field('user_personal_data[postcode]').value).to eq 'NW6 8ET'
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
end