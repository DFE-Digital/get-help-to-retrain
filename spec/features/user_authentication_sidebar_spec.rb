require 'rails_helper'

RSpec.feature 'User authentication in sidebar' do
  let!(:job_profile1) do
    create(
      :job_profile,
      :with_html_content,
      name: 'Hitman',
      skills: [create(:skill, name: 'Baldness')]
    )
  end

  let(:paths) {
    [
      root_path,
      your_information_path,
      task_list_path,
      skills_path,
      check_your_skills_path,
      results_check_your_skills_path,
      job_profile_skills_path(job_profile1.slug),
      skills_matcher_index_path,
      job_profile_path(job_profile1.slug),
      courses_path('english')
    ]
  }

  before do
    client = instance_spy(Notifications::Client)
    allow(Notifications::Client).to receive(:new).and_return(client)
  end

  def fill_in_user_personal_information
    visit(your_information_path)
    fill_in('user_personal_data[first_name]', with: 'John')
    fill_in('user_personal_data[last_name]', with: 'Mayer')
    fill_in('user_personal_data[postcode]', with: 'NW6 1JJ')
    fill_in('user_personal_data[birth_day]', with: '1')
    fill_in('user_personal_data[birth_month]', with: '1')
    fill_in('user_personal_data[birth_year]', with: DateTime.now.year - 20)
    choose('user_personal_data[gender]', option: 'male')
    click_on('Continue')
  end

  def register_user
    visit(save_your_results_path)
    fill_in('email', with: 'test@test.test')
    page.driver.header('User-Agent', 'some-agent')
    click_on('Save your progress')
  end

  context 'when user saves their progress' do
    scenario 'user sees save your results in sidebar after filling PID form' do
      fill_in_user_personal_information

      paths.each do |path|
        visit(path)

        expect(page).to have_text('Save your progress')
      end
    end

    scenario 'user does not see save your results in sidebar if user registered' do
      fill_in_user_personal_information
      register_user

      paths.each do |path|
        visit(path)

        expect(page).not_to have_text('Save your progress')
      end
    end

    scenario 'user does not see save your results in sidebar if user existed before' do
      fill_in_user_personal_information
      register_user
      Capybara.reset_sessions!
      register_user

      paths.each do |path|
        visit(path)

        expect(page).not_to have_text('Save your progress')
      end
    end

    scenario 'user does not see save your results before filling PID form' do
      paths.each do |path|
        visit(path)

        expect(page).not_to have_text('Save your progress')
      end
    end
  end

  context 'when user signs in' do
    scenario 'user sees return to saved results in sidebar before filling PID form' do
      paths.each do |path|
        visit(path)

        expect(page).to have_text('Return to saved progress')
      end
    end

    scenario 'user sees return to saved progress in sidebar if user registered' do
      register_user

      paths.each do |path|
        visit(path)

        expect(page).to have_text('Return to saved progress')
      end
    end

    scenario 'user sees return to saved results in sidebar if user gets validation errors on PID form' do
      visit(your_information_path)
      click_on('Continue')

      expect(page).to have_text('Return to saved progress')
    end

    scenario 'user does not see return to save results after filling in PID form' do
      fill_in_user_personal_information
      paths.each do |path|
        visit(path)

        expect(page).not_to have_text('Return to saved progress')
      end
    end

    scenario 'user does not see return to saved progress in sidebar if user sign in through registration' do
      register_user
      click_on('send it again')
      Capybara.reset_sessions!
      visit(token_sign_in_path(token: Passwordless::Session.last.token))

      paths.each do |path|
        visit(path)

        expect(page).not_to have_text('Return to saved progress')
      end
    end

    scenario 'user does not see return to saved progress in sidebar if user signs in through sign in' do
      register_user

      visit(return_to_saved_results_path)
      fill_in('email', with: 'test@test.test')
      click_on('Send link')
      Capybara.reset_sessions!
      visit(token_sign_in_path(token: Passwordless::Session.last.token))

      paths.each do |path|
        visit(path)

        expect(page).not_to have_text('Return to saved progress')
      end
    end

    scenario 'user sees save your results in sidebar if user sends sign in email through sign in' do
      visit(return_to_saved_results_path)
      fill_in('email', with: 'test@test.test')
      click_on('Send link')
      fill_in_user_personal_information

      paths.each do |path|
        visit(path)

        expect(page).to have_text('Save your progress')
      end
    end

    scenario 'user does not see save your results in sidebar if user signs in' do
      register_user

      visit(return_to_saved_results_path)
      fill_in('email', with: 'test@test.test')
      click_on('Send link')
      Capybara.reset_sessions!
      visit(token_sign_in_path(token: Passwordless::Session.last.token))

      paths.each do |path|
        visit(path)

        expect(page).not_to have_text('Save your progress')
      end
    end
  end
end
