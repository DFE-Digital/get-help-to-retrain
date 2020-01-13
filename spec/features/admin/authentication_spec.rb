require 'rails_helper'

RSpec.feature 'Admin Users Authentication' do
  before do
    allow(Rails.configuration).to receive(:admin_mode).and_return(true)
    create(:admin_role, name: 'management', resource_id: 'be91dffe-b6bcb')
  end

  let(:jwt) {
    {
      'token' => 'eyJ0eXAiOiJKV1QiLCJub25jZSI',
      'expires_at' => 1_576_675_451,
      'expires' => true
    }
  }

  let(:user_info) {
    {
      '@odata.context' => 'https://graph.microsoft.com/v1.0/$metadata#users/$entity',
      'businessPhones' => [],
      'displayName' => 'some.name',
      'givenName' => nil,
      'jobTitle' => nil,
      'mail' => 'test@test.com',
      'id' => '1111-111-11-1'
    }
  }

  let(:user_roles) {
    [
      {
        '@odata.type' => '#microsoft.graph.group',
        'id' => 'be91dffe-b6bcb',
        'displayName' => 's108-gethelptoretrain-app-management USR'
      }
    ]
  }

  let(:complete_azure_ad_response) {
    {
      'provider' => :azure_ad_auth,
      'uid' => '1111-111-11-1',
      'info' => {
        'email' => 'test@test.com',
        'name' => 'some.name'
      },
      'credentials' => jwt,
      'extra' => {
        'raw_info' => user_info,
        'user_roles' => {
          'value' => user_roles
        }
      }
    }
  }

  let(:incomplete_azure_ad_response) {
    {
      'provider' => :azure_ad_auth,
      'uid' => '1111-111-11-1',
      'credentials' => jwt
    }
  }

  scenario 'Redirects to active admin dashboard page if authentication is successfuly and page has user\'s name and the Logout link' do
    stub_omniauth

    visit(auth_azure_ad_auth_callback_path)

    ['Dashboard', 'some.name', 'Logout'].each do |content|
      expect(page).to have_content(content)
    end
  end

  scenario 'Stores the user details on successful authentication' do
    stub_omniauth

    visit(auth_azure_ad_auth_callback_path)

    expect(AdminUser.last).to have_attributes(
      name: 'some.name',
      resource_id: '1111-111-11-1',
      email: 'test@test.com'
    )
  end

  scenario 'Redirects to sign in page if omniauth hash is missing required information' do
    stub_omniauth(payload: incomplete_azure_ad_response)

    visit(auth_azure_ad_auth_callback_path)

    expect(page).to have_current_path(admin_sign_in_path)
  end

  scenario 'User sees the failure messages in case of unsuccessful authorisation' do
    stub_omniauth(payload: incomplete_azure_ad_response)

    visit(auth_azure_ad_auth_callback_path)

    expect(page).to have_content('We could not authenticate you.')
  end

  scenario 'When user clicks Logout, one can not access the dashboard anymore without loging back in' do
    stub_omniauth

    visit(auth_azure_ad_auth_callback_path)

    click_on('Logout')

    visit(admin_job_profiles_path)

    expect(page).to have_current_path(admin_sign_in_path)
  end

  scenario 'Deep linking to sign-in page when already logged will redirect to the active admin dashboard page' do
    stub_omniauth

    visit(auth_azure_ad_auth_callback_path)

    visit(admin_sign_in_path)

    expect(page).to have_current_path(root_path)
  end

  def stub_omniauth(payload: complete_azure_ad_response)
    OmniAuth.config.test_mode = true

    omniauth_hash = OmniAuth::AuthHash.new(payload)

    OmniAuth.config.add_mock(:azure_ad_auth, omniauth_hash)
  end
end
