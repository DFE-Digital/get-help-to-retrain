require 'rails_helper'

RSpec.feature 'User sign in' do
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
  let!(:skill1) { create(:skill, name: 'Chameleon-like blend in tactics') }
  let!(:skill2) { create(:skill, name: 'License to kill') }
  let!(:skill3) { create(:skill, name: 'Baldness') }

  let!(:job_profile) do
    create(
      :job_profile,
      :with_html_content,
      name: 'Hitman',
      skills: [
        skill1,
        skill2,
        skill3
      ]
    )
  end

  def register_user
    visit(save_your_results_path)
    fill_in('email', with: 'test@test.test')
    page.driver.header('User-Agent', 'some-agent')

    click_on('Save your results')
  end

  def send_sign_in_email
    visit(root_path)
    fill_in('email', with: 'test@test.test')
    page.driver.header('User-Agent', 'some-agent')
    click_on('Send a link')
  end

  def sign_in_user(reset_sessions: true)
    send_sign_in_email
    Capybara.reset_sessions! if reset_sessions
    visit(token_sign_in_path(token: Passwordless::Session.last.token))
  end

  before do
    enable_feature!(:user_authentication, :skills_builder_v2)
    allow(Notifications::Client).to receive(:new).and_return(client)
  end

  scenario 'User gets relevant messaging if no email is entered' do
    visit(root_path)
    click_on('Send a link')

    expect(page).to have_text(/Enter an email address/)
  end

  scenario 'User gets relevant messaging if invalid email is entered' do
    visit(root_path)
    fill_in('email', with: 'wrong email')
    click_on('Send a link')

    expect(page).to have_text(/Enter a valid email address/)
  end

  scenario 'User is redirected back to page if email invalid with email' do
    visit(root_path)
    fill_in('email', with: 'wrong-email')
    click_on('Send a link')

    expect(page).to have_current_path(root_path(email: 'wrong-email'))
  end

  scenario 'User does not see validation error if they continue on from page' do
    visit(root_path)
    fill_in('email', with: 'wrong email')
    click_on('Send a link')
    click_on('Start')

    expect(page).not_to have_text(/Enter a valid email address/)
  end

  scenario 'User redirected to link sent page if email is valid and user exists' do
    register_user
    send_sign_in_email

    expect(page).to have_current_path(link_sent_path(email: 'test@test.test'))
  end

  scenario 'User redirected to link sent page if email is valid and user does not exists' do
    send_sign_in_email

    expect(page).to have_current_path(link_sent_path(email: 'test@test.test'))
  end

  scenario 'User can see their email on link page is user exists' do
    register_user
    send_sign_in_email

    expect(page).to have_text(/test@test.test/)
  end

  scenario 'User can see their email on link page is user does not exists' do
    send_sign_in_email

    expect(page).to have_text(/test@test.test/)
  end

  scenario 'User does not get error message if they enter their same email but different case' do
    register_user
    visit(root_path)
    fill_in('email', with: 'Test@Test.Test')
    page.driver.header('User-Agent', 'some-agent')
    click_on('Send a link')

    expect(page).to have_current_path(link_sent_path(email: 'test@test.test'))
  end

  scenario 'User can resend email and is redirected to same page' do
    register_user
    send_sign_in_email
    click_on('send it again')

    expect(page).to have_current_path(link_sent_path(email: 'test@test.test'))
  end

  scenario 'User receives sign in email if email valid and user exists' do
    register_user
    send_sign_in_email

    expect(client).to have_received(:send_email)
      .with(confirmation_email)
      .with(sign_in_email)
  end

  scenario 'User does not receives sign in email if email valid and user does not exists' do
    send_sign_in_email

    expect(client).not_to have_received(:send_email)
      .with(sign_in_email)
  end

  scenario 'User receives sign in email if they enter their same email but different case' do
    register_user
    visit(root_path)
    fill_in('email', with: 'Test@Test.Test')
    page.driver.header('User-Agent', 'some-agent')
    click_on('Send a link')

    expect(client).to have_received(:send_email)
      .with(confirmation_email)
      .with(sign_in_email)
  end

  scenario 'User receives sign in email twice if they click send email again' do
    register_user
    send_sign_in_email
    click_on('send it again')

    expect(client).to have_received(:send_email)
      .with(confirmation_email)
      .with(sign_in_email)
      .twice
  end

  scenario 'user restores their session after signing in' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('Baldness', allow_label_click: true)
    click_on('Select these skills')
    register_user
    sign_in_user
    visit(skills_path)

    expect(page).to have_selector('tbody tr', count: 2)
  end

  scenario 'if user registers, continues journey then signs in, their session is restored' do
    register_user
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('Baldness', allow_label_click: true)
    click_on('Select these skills')
    sign_in_user
    visit(skills_path)

    expect(page).to have_selector('tbody tr', count: 2)
  end

  scenario 'if user signs in, continues journey then signs in again, their session is restored' do
    register_user
    sign_in_user
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('Baldness', allow_label_click: true)
    click_on('Select these skills')
    Capybara.reset_sessions!
    sign_in_user
    visit(skills_path)

    expect(page).to have_selector('tbody tr', count: 2)
  end

  scenario 'user restores their session after signing in with same session' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('Baldness', allow_label_click: true)
    click_on('Select these skills')
    register_user
    sign_in_user(reset_sessions: false)
    visit(skills_path)

    expect(page).to have_selector('tbody tr', count: 2)
  end

  scenario 'if user registers, continues journey then signs in, their session is restored with same session' do
    register_user
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('Baldness', allow_label_click: true)
    click_on('Select these skills')
    sign_in_user(reset_sessions: false)
    visit(skills_path)

    expect(page).to have_selector('tbody tr', count: 2)
  end

  scenario 'if user signs in, continues journey then signs in again, their session is restored with same session' do
    register_user
    sign_in_user(reset_sessions: false)
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('Baldness', allow_label_click: true)
    click_on('Select these skills')
    Capybara.reset_sessions!
    sign_in_user
    visit(skills_path)

    expect(page).to have_selector('tbody tr', count: 2)
  end

  scenario 'if user signs in, they should be redirected to task list page' do
    register_user
    sign_in_user

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'if user signs in, and token expired user should be redirected to 404' do
    register_user
    send_sign_in_email
    Capybara.reset_sessions!
    Passwordless::Session.last.update(timeout_at: Time.now - 1.day)

    expect {
      visit(token_sign_in_path(token: Passwordless::Session.last.token))
    }.to raise_error(ActionController::RoutingError)
  end

  scenario 'if user signs in, and token claimed user should be redirected to 404' do
    register_user
    sign_in_user

    expect {
      visit(token_sign_in_path(token: Passwordless::Session.last.token))
    }.to raise_error(ActionController::RoutingError)
  end
end
