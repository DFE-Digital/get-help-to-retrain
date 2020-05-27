module PersonalData
  def fill_pid_form
    visit(root_path)
    click_on('Accept all cookies')
    click_on('Start now')
    fill_in_fields
    click_on('Continue')
  end

  def fill_in_fields
    fill_in('user_personal_data[first_name]', with: 'John')
    fill_in('user_personal_data[last_name]', with: 'Mayer')
    fill_in('user_personal_data[postcode]', with: 'NW6 8ET')
    fill_in('user_personal_data[birth_day]', with: '1')
    fill_in('user_personal_data[birth_month]', with: '1')
    fill_in('user_personal_data[birth_year]', with: DateTime.now.year - 20)
    find('#user_personal_data_gender_male', visible: :all).click
  end
end

RSpec.configure do |config|
  config.include PersonalData
end
