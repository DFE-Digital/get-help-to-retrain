require 'rails_helper'

RSpec.feature 'Admin Users Authentication' do
  before do
    allow(Rails.configuration).to receive(:admin_mode).and_return(true)
    allow(Rails.configuration).to receive(:azure_management_role_id).and_return('be91dffe-b6bcb')

    AdminUser.create(resource_id: '1111-111-11-1')

    stub_omniauth

    visit(auth_azure_ad_auth_callback_path)
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

  scenario 'It has an Audit Logs section' do
    expect(page).to have_content('Audit Logs')
  end

  scenario 'When a user visits user personal data page that event gets logged' do
    create(:user_personal_data)

    click_on('User Personal Data')
    click_on('Audit Logs')

    ['User Personal Data Page', 'visited page'].each do |content|
      expect(page).to have_content(content)
    end
  end

  scenario 'Using the filters on user personal data page gets logged' do
    create(:user_personal_data, first_name: 'James')
    create(:user_personal_data, first_name: 'Jamie')

    click_on('User Personal Data')
    fill_in('q_first_name', with: 'Jamie')
    click_on('Filter')
    click_on('Audit Logs')
    all('.view_link')[1].click

    ['Results found: 1', 'Searched for:', 'First name contains: Jamie'].each do |content|
      expect(page).to have_content(content)
    end
  end

  scenario 'Using the filters without any filter input on user personal data page still gets logged' do
    create(:user_personal_data, first_name: 'James')
    create(:user_personal_data, first_name: 'Jamie')

    click_on('User Personal Data')
    click_on('Filter')
    click_on('Audit Logs')
    all('.view_link')[1].click

    ['Results found: 2', 'Searched for:'].each do |content|
      expect(page).to have_content(content)
    end
  end

  scenario 'When a user downloads the user personal data as CSV that event gets logged' do
    create(:user_personal_data)

    click_on('User Personal Data')
    click_on('CSV')
    visit(admin_audit_logs_path)

    ['User Personal Data Page', 'downloaded CSV'].each do |content|
      expect(page).to have_content(content)
    end
  end

  scenario 'When a user deletes a user personal data record that event gets logged' do
    create(:user_personal_data)

    click_on('User Personal Data')
    click_on('Delete')
    visit(admin_audit_logs_path)

    ['User Personal Data Page', 'destroy'].each do |content|
      expect(page).to have_content(content)
    end
  end

  scenario 'When a user checks a particular user personal data record that event gets logged' do
    user_personal_data = create(:user_personal_data)

    click_on('User Personal Data')
    click_on('View')
    visit(admin_audit_logs_path)

    ['User Personal Data Page', 'visited record', user_personal_data.id].each do |content|
      expect(page).to have_content(content)
    end
  end

  scenario 'When a tracked resource updates it shows a readable diff of the changes' do
    create(:job_profile, name: 'therapist', growth: 12.3)

    click_on('Job Profiles')
    click_on('Edit')
    fill_in('job_profile_growth', with: 10)
    uncheck('Recommended', allow_label_click: true)
    click_on('Update Job profile')
    click_on('Audit Logs')
    all('.view_link').first.click

    ['growth: 12.3 -> 10.0', 'recommended: true -> false'].each do |content|
      expect(page).to have_content(content)
    end
  end

  def stub_omniauth(payload: complete_azure_ad_response)
    OmniAuth.config.test_mode = true

    omniauth_hash = OmniAuth::AuthHash.new(payload)

    OmniAuth.config.add_mock(:azure_ad_auth, omniauth_hash)
  end
end
