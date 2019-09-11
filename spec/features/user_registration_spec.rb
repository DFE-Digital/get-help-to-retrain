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
    click_on('Save your results')
  end

  before do
    enable_feature!(:user_authentication, :skills_builder_v2)
    allow(Notifications::Client).to receive(:new).and_return(client)
  end

  scenario 'user sees save your results page when navigating from sidebar' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    find('.govuk-button').click
    click_on('Save my results')
    expect(page).to have_current_path(save_your_results_path)
  end

  scenario 'User gets relevant messaging if no email is entered' do
    visit(save_your_results_path)
    click_on('Save your results')

    expect(page).to have_text(/Enter an email address/)
  end

  scenario 'User gets relevant messaging if invalid email is entered' do
    visit(save_your_results_path)
    fill_in('email', with: 'wrong email')
    click_on('Save your results')

    expect(page).to have_text(/Enter a valid email address/)
  end

  scenario 'User is taken to link sent page after entering email to save results' do
    register_user

    expect(page).to have_text(/Your results have been saved/)
  end

  scenario 'User can see their email on link page' do
    register_user

    expect(page).to have_text(/test@test.test/)
  end

  scenario 'User can go back to registration page to amend their email' do
    register_user
    click_on('enter your email address again')

    expect(page).to have_text(/Save your results/)
  end

  scenario 'User can resend email and is redirected to same page' do
    register_user
    click_on('send it again')

    expect(page).to have_text(/Your results have been saved/)
  end

  scenario 'User can resume their journey to where they first clicked save my results' do
    visit(next_steps_path)
    click_on('Save my results')
    fill_in('email', with: 'test@test.test')
    click_on('Save your results')
    click_on('Continue')

    expect(page).to have_current_path(next_steps_path)
  end

  scenario 'User redirected to task list page if they directly linked to save results page' do
    register_user
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
end
