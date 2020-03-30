require 'rails_helper'

RSpec.feature 'User registration' do
  let(:client) { instance_spy(Notifications::Client) }
  let(:confirmation_email) do
    {
      email_address: 'test@test.test',
      template_id: NotifyService::CONFIRMATION_TEMPLATE_ID,
      personalisation: {
        'URL' => /http/
      }
    }
  end

  let(:sign_in_email) do
    {
      email_address: 'test@test.test',
      template_id: NotifyService::LINK_TO_RESULTS_TEMPLATE_ID,
      personalisation: {
        'LINK' => /sign-in/
      }
    }
  end

  let!(:job_profile) do
    create(
      :job_profile,
      :with_skill,
      :with_html_content,
      name: 'Hitman'
    )
  end

  def register_user
    visit(save_your_results_path)
    fill_in('email', with: 'test@test.test')
    page.driver.header('User-Agent', 'some-agent')
    click_on('Save your progress')
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

  before do
    allow(Notifications::Client).to receive(:new).and_return(client)
  end

  scenario 'user sees save your results page when navigating from sidebar' do
    fill_in_user_personal_information
    click_on('Save your progress')

    expect(page).to have_current_path(save_your_results_path)
  end

  scenario 'user can go back to the task list page' do
    fill_in_user_personal_information
    click_on('Save your progress')
    click_on('Back')

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'User gets relevant messaging if no email is entered' do
    visit(save_your_results_path)
    click_on('Save your progress')

    expect(page).to have_text(/Enter an email address/)
  end

  scenario 'Error summary message present if no email is entered' do
    visit(save_your_results_path)
    click_on('Save your progress')

    expect(page).to have_content('There is a problem')
  end

  scenario 'Error summary contains error if no email is entered' do
    visit(save_your_results_path)
    click_on('Save your progress')

    expect(page.all('ul.govuk-error-summary__list li a').collect(&:text)).to eq(
      [
        'Enter an email address'
      ]
    )
  end

  scenario 'User gets relevant messaging if invalid email is entered' do
    visit(save_your_results_path)
    fill_in('email', with: 'wrong email')
    click_on('Save your progress')

    expect(page).to have_text(/Enter a valid email address/)
  end

  scenario 'User is taken to link sent page after entering email to save results' do
    register_user

    expect(page).to have_text(/Your progress has been saved/)
  end

  scenario 'User will be taken to the save your progress path when clicking Back' do
    register_user
    click_on('Back')

    expect(page).to have_current_path(save_your_progress_path)
  end

  scenario 'User can see their email on link page' do
    register_user

    expect(page).to have_text(/test@test.test/)
  end

  scenario 'User can go back to registration page to amend their email' do
    register_user
    click_on('enter your email address again')

    expect(page).to have_text(/Save your progress/)
  end

  scenario 'User can go back to task list path after trying to send the email again' do
    register_user
    click_on('enter your email address again')
    click_on('Back')

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'User does not get error message if they enter their same email but different case' do
    register_user
    click_on('enter your email address again')
    fill_in('email', with: 'Test@Test.test')
    click_on('Save your progress')

    expect(page).to have_text(/Your progress has been saved/)
  end

  scenario 'User can resend email and is redirected to email sent page' do
    register_user
    click_on('send it again')

    expect(page).to have_current_path(email_sent_again_path)
  end

  scenario 'User can go back to the previous page from link sent page' do
    register_user
    click_on('send it again')
    click_on('Back')

    expect(page).to have_current_path(save_your_progress_path)
  end

  scenario 'User does not get stuck in a weird state trying to click Back twice starting from link sent page' do
    register_user
    click_on('send it again')
    click_on('Back')
    click_on('Back')

    expect(page).to have_current_path(root_path)
  end

  scenario 'User resends email and can see their email on email sent again page' do
    register_user
    click_on('send it again')

    expect(page).to have_text(/test@test.test/)
  end

  scenario 'User can resume their journey from resend page to where they first clicked save my results' do
    fill_in_user_personal_information
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')
    click_on('Save your progress')
    visit(skills_matcher_index_path)
    click_on('Save your progress')
    fill_in('email', with: 'test@test.test')
    click_on('Save your progress')
    click_on('send it again')
    click_on('Continue')

    expect(page).to have_current_path(skills_matcher_index_path)
  end

  scenario 'When NotifyService is down, the user sees the correct error page when one tries to save results' do
    allow(Notifications::Client).to receive(:new).and_raise(ArgumentError)

    fill_in_user_personal_information
    click_on('Save your progress')
    fill_in('email', with: 'test@test.test')
    click_on('Save your progress')

    expect(page).to have_current_path(save_results_error_path)
  end

  scenario 'When NotifyService is down, user can resume the journey from the point one tries saving the results' do
    allow(Notifications::Client).to receive(:new).and_raise(ArgumentError)

    fill_in_user_personal_information
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')
    visit(skills_matcher_index_path)
    click_on('Save your progress')
    fill_in('email', with: 'test@test.test')
    click_on('Save your progress')

    click_on('Continue')

    expect(page).to have_current_path(skills_matcher_index_path)
  end

  scenario 'User can resume their journey to where they first clicked save my results' do
    fill_in_user_personal_information
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')
    click_on('Save your progress')
    visit(skills_matcher_index_path)
    click_on('Save your progress')
    fill_in('email', with: 'test@test.test')
    click_on('Save your progress')
    click_on('Continue')

    expect(page).to have_current_path(skills_matcher_index_path)
  end

  scenario 'User redirected to task list page if they directly linked to email sent page' do
    register_user
    click_on('send it again')
    click_on('Continue')

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'User redirected to task list page if they directly linked to save results page' do
    register_user
    click_on('Continue')

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'User redirected to task list page if they went back from save your results page' do
    register_user
    click_on('enter your email address again')
    fill_in('email', with: 'test@test.test')
    click_on('Save your progress')
    click_on('Continue')

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'User redirected to task list page if they went back from save your results page on resend' do
    register_user
    click_on('enter your email address again')
    fill_in('email', with: 'test@test.test')
    click_on('Save your progress')
    click_on('send it again')
    click_on('Continue')

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'User sent confirmation email when registering for first time' do
    register_user

    expect(client).to have_received(:send_email).with(confirmation_email)
  end

  scenario 'User sent sign in email if already registered' do
    register_user
    register_user

    expect(client).to have_received(:send_email)
      .with(confirmation_email)
      .with(sign_in_email)
  end

  scenario 'User sent sign in email if they click send email again' do
    register_user
    click_on('send it again')

    expect(client).to have_received(:send_email)
      .with(confirmation_email)
      .with(sign_in_email)
  end

  scenario 'User sent sign in email if they enter their same email but in different case' do
    register_user
    click_on('enter your email address again')
    fill_in('email', with: 'Test@Test.test')
    click_on('Save your progress')

    expect(client).to have_received(:send_email)
      .with(confirmation_email)
      .with(sign_in_email)
  end

  scenario 'User registration is tracked if successful' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    register_user

    expect(tracking_service).to have_received(:track_events).with(
      props:
      [
        {
          key: :progress,
          label: 'Saved progress',
          value: 'save_journey'
        }
      ]
    )
  end

  scenario 'Existing user registration is tracked if successful' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    register_user
    register_user

    expect(tracking_service).to have_received(:track_events).with(
      props:
      [
        {
          key: :progress,
          label: 'Returned to progress button',
          value: 'return_journey'
        }
      ]
    )
  end

  scenario 'User registration is not tracked if invalid' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    visit(save_your_results_path)
    fill_in('email', with: 'wrong email')
    click_on('Save your progress')

    expect(tracking_service).not_to have_received(:track_events)
  end
end
