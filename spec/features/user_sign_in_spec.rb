require 'rails_helper'

RSpec.feature 'User sign in' do
  let(:client) { instance_spy(Notifications::Client) }
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

  def sign_in_user
    register_user
    click_on('send it again')
    Capybara.reset_sessions!
    visit(token_sign_in_path(token: Passwordless::Session.last.token))
  end

  before do
    enable_feature!(:user_authentication, :skills_builder_v2)
    allow(Notifications::Client).to receive(:new).and_return(client)
  end

  scenario 'user restores their session after signing in' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('Baldness', allow_label_click: true)
    find('.govuk-button').click
    sign_in_user
    visit(skills_path)

    expect(page).to have_selector('tbody tr', count: 2)
  end

  scenario 'if user registers, continues journey then signs in, their session is restored' do
    register_user
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('Baldness', allow_label_click: true)
    find('.govuk-button').click
    sign_in_user
    visit(skills_path)

    expect(page).to have_selector('tbody tr', count: 2)
  end

  scenario 'if user signs in, continues journey then signs in again, their session is restored' do
    sign_in_user
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('Baldness', allow_label_click: true)
    find('.govuk-button').click
    sign_in_user
    visit(skills_path)

    expect(page).to have_selector('tbody tr', count: 2)
  end
end
