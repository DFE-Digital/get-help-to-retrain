require 'rails_helper'

RSpec.describe AdminUser do
  subject(:admin_user) { described_class.new }

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

  let(:auth_hash) {
    {
      'provider' => :azure_ad_auth,
      'uid' => '1111-111-11-1',
      'credentials' => jwt,
      'extra' => {
        'user_info' => user_info,
        'user_roles' => {
          'value' => user_roles
        }
      }
    }.with_indifferent_access
  }

  describe '#from_omniauth' do
    it 'stores the user details in the db' do
      described_class.from_omniauth(auth_hash)

      expect(described_class.last).to have_attributes(
        name: 'some.name',
        resource_id: '1111-111-11-1',
        email: 'test@test.com'
      )
    end

    it 'does not store user details if user_info key has incomplete data' do
      auth_hash = {
        'provider' => :azure_ad_auth,
        'uid' => '1111-111-11-1',
        'credentials' => jwt,
        'extra' => {
          'user_info' => {
            'id' => '1111-111-11-1'
          }
        }
      }.with_indifferent_access

      expect {
        described_class.from_omniauth(auth_hash)
      }.not_to change(described_class, :count)
    end
  end

  describe '#roles_from' do
    it 'returns the user role ids' do
      expect(admin_user.roles_from(auth_hash)).to contain_exactly('be91dffe-b6bcb')
    end

    it 'returns an empty array if user_roles key holds no roles' do
      auth_hash = {
        'provider' => :azure_ad_auth,
        'uid' => '1111-111-11-1',
        'credentials' => jwt,
        'extra' => {
          'user_roles' => {
            'value' => nil
          }
        }
      }.with_indifferent_access

      expect(admin_user.roles_from(auth_hash)).to be_empty
    end
  end
end
