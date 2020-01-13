require 'rails_helper'

RSpec.feature 'Admin Users Authentication' do
  before do
    allow(Rails.configuration).to receive(:admin_mode).and_return(true)
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
        'displayName' => 's108-gethelptoretrain-app USR'
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

  scenario 'User sees failure messages if they do not belong to any groups' do
    create(:admin_role, name: 'management', resource_id: 'another-id')
    stub_omniauth
    visit(auth_azure_ad_auth_callback_path)

    expect(page).to have_content('We could not authenticate you.')
  end

  scenario 'Management user can manage user personal data' do
    create(:user_personal_data)
    create(:admin_role, name: 'management', resource_id: 'be91dffe-b6bcb')

    stub_omniauth
    visit(auth_azure_ad_auth_callback_path)
    visit(admin_user_personal_data_path)

    %w[View Edit Delete].each do |content|
      expect(page).to have_content(content)
    end
  end

  scenario 'Management user can manage job profiles' do
    create(:job_profile)
    create(:admin_role, name: 'management', resource_id: 'be91dffe-b6bcb')

    stub_omniauth
    visit(auth_azure_ad_auth_callback_path)
    visit(admin_job_profiles_path)

    %w[View Edit].each do |content|
      expect(page).to have_content(content)
    end
  end

  scenario 'ReadWrite user cannot manage user personal data' do
    create(:user_personal_data)
    create(:admin_role, name: 'readwrite', resource_id: 'be91dffe-b6bcb')

    stub_omniauth
    visit(auth_azure_ad_auth_callback_path)
    visit(admin_user_personal_data_path)

    expect(page).to have_content('You are not authorised to perform this action.')
  end

  scenario 'ReadWrite user can manage job profiles' do
    create(:job_profile)
    create(:admin_role, name: 'readwrite', resource_id: 'be91dffe-b6bcb')

    stub_omniauth
    visit(auth_azure_ad_auth_callback_path)
    visit(admin_job_profiles_path)

    %w[View Edit].each do |content|
      expect(page).to have_content(content)
    end
  end

  scenario 'Read user cannot read user personal data' do
    create(:user_personal_data)
    create(:admin_role, name: 'read', resource_id: 'be91dffe-b6bcb')

    stub_omniauth
    visit(auth_azure_ad_auth_callback_path)
    visit(admin_user_personal_data_path)

    expect(page).to have_content('You are not authorised to perform this action.')
  end

  scenario 'Read user can only read job profiles' do
    create(:job_profile)
    create(:admin_role, name: 'read', resource_id: 'be91dffe-b6bcb')

    stub_omniauth
    visit(auth_azure_ad_auth_callback_path)
    visit(admin_job_profiles_path)

    expect(page).not_to have_content('Edit')
  end

  def stub_omniauth(payload: complete_azure_ad_response)
    OmniAuth.config.test_mode = true
    omniauth_hash = OmniAuth::AuthHash.new(payload)
    OmniAuth.config.add_mock(:azure_ad_auth, omniauth_hash)
  end
end
