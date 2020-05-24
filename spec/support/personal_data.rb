module PersonalData
  def js_enabled?
    RSpec.current_example.metadata[:js]
  end

  def fill_pid_form
    visit(your_information_path)
    find('input[value="Accept all cookies"]').click if js_enabled?
    fill_in('user_personal_data[first_name]', with: 'John')
    fill_in('user_personal_data[last_name]', with: 'Mayer')
    fill_in('user_personal_data[postcode]', with: 'NW6 8ET')
    fill_in('user_personal_data[birth_day]', with: '1')
    fill_in('user_personal_data[birth_month]', with: '1')
    fill_in('user_personal_data[birth_year]', with: DateTime.now.year - 20)
    find('#user_personal_data_gender_male', visible: :all).click
    click_on('Continue')
  end
end

RSpec.configure do |config|
  config.include PersonalData
end
