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

  let!(:job_profile) {
    create(:job_profile, name: 'therapist', growth: 12.3)
  }

  let!(:user_personal_data) {
    create(:user_personal_data)
  }

  let!(:admin_user) {
    AdminUser.create(resource_id: '1111-111-11-1')
  }

  before do
    stub_omniauth

    visit(auth_azure_ad_auth_callback_path)
  end

  scenario 'It has an Audit Logs section' do
    expect(page).to have_content('Audit Logs')
  end

  scenario 'When a user visits user personal data page that event gets logged' do
    click_on('User Personal Data')
    click_on('Audit Logs')

    ['User Personal Data Page', 'visited page'].each do |content|
      expect(page).to have_content(content)
    end
  end

  scenario 'When a user downloads the user personal data as CSV that event gets logged' do
    click_on('User Personal Data')
    click_on('CSV')
    visit(admin_audit_logs_path)
    
    ['User Personal Data Page', 'downloaded CSV'].each do |content|
      expect(page).to have_content(content)
    end
  end

  scenario 'When a user deletes a user personal data record that event gets logged' do
    click_on('User Personal Data')
    click_on('Delete')
    visit(admin_audit_logs_path)
    
    ['User Personal Data Page', 'record deleted'].each do |content|
      expect(page).to have_content(content)
    end
  end

  scenario 'When a tracked resource updates it shows a readable diff of the changes' do
    click_on('Job Profiles')
    click_on('Edit')
    fill_in('job_profile_growth', with: 10)
    uncheck('Recommended', allow_label_click: true)
    click_on('Update Job profile')
    click_on('Audit Logs')
    click_on('View')

    ['growth value changed from: 12.3 -> 10.0', 'recommended value changed from: true -> false'].each do |content|
      expect(page).to have_content(content)
    end
  end

  def stub_omniauth(payload: complete_azure_ad_response)
    OmniAuth.config.test_mode = true

    omniauth_hash = OmniAuth::AuthHash.new(payload)

    OmniAuth.config.add_mock(:azure_ad_auth, omniauth_hash)
  end
end
