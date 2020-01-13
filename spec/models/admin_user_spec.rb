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
    }.with_indifferent_access
  }

  describe '.has_role?' do
    it 'returns true if user belongs to a given role' do
      user = create(
        :admin_user,
        roles: [
          create(:admin_role, name: 'management'),
          create(:admin_role, name: 'read')
        ]
      )

      expect(user.has_role?('read')).to eq(true)
    end

    it 'returns false if user does not belong to role' do
      user = create(:admin_user)

      expect(user.has_role?('read')).to eq(false)
    end
  end

  describe '.from_omniauth' do
    it 'returns an active record instance with correct attributes' do
      active_admin = described_class.from_omniauth(auth_hash)

      expect(active_admin).to have_attributes(
        name: 'some.name',
        resource_id: '1111-111-11-1',
        email: 'test@test.com'
      )
    end

    it 'returns a valid active record instance' do
      active_admin = described_class.from_omniauth(auth_hash)

      expect(active_admin.valid?).to be true
    end

    it 'returns an invalid active record instance if user_info key has incomplete data' do
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

      active_admin = described_class.from_omniauth(auth_hash)

      expect(active_admin.valid?).to be false
    end

    it 'sets admin user roles to a single role if set in auth hash' do
      management = create(:admin_role, name: 'management', resource_id: 'be91dffe-b6bcb')
      admin_user = described_class.from_omniauth(auth_hash)

      expect(admin_user.roles).to contain_exactly(management)
    end

    it 'sets admin user roles to multiple roles if set in auth hash' do
      user_roles = [
        {
          '@odata.type' => '#microsoft.graph.group',
          'id' => 'be91dffe-b6bcb',
          'displayName' => 's108-gethelptoretrain-app-management USR'
        },
        {
          '@odata.type' => '#microsoft.graph.group',
          'id' => 'fe91dffe-sdf7s',
          'displayName' => 's108-gethelptoretrain-app-read USR'
        }
      ]

      auth_hash = {
        'provider' => :azure_ad_auth,
        'uid' => '1111-111-11-1',
        'credentials' => jwt,
        'extra' => {
          'user_roles' => {
            'value' => user_roles
          }
        }
      }.with_indifferent_access

      management = create(:admin_role, name: 'management', resource_id: 'be91dffe-b6bcb')
      read = create(:admin_role, name: 'read', resource_id: 'fe91dffe-sdf7s')
      admin_user = described_class.from_omniauth(auth_hash)

      expect(admin_user.roles).to contain_exactly(management, read)
    end

    it 'updates admin user roles if user already exists' do
      admin_user = create(
        :admin_user,
        roles: [create(:admin_role, name: 'read')],
        name: 'some.name',
        resource_id: '1111-111-11-1',
        email: 'test@test.com'
      )
      management = create(:admin_role, name: 'management', resource_id: 'be91dffe-b6bcb')
      updated_user = described_class.from_omniauth(auth_hash)
      updated_user.save

      expect(admin_user.reload.roles).to contain_exactly(management)
    end

    it 'does not set admin user roles if no role set in auth hash' do
      auth_hash = {
        'provider' => :azure_ad_auth,
        'uid' => '1111-111-11-1',
        'credentials' => jwt,
        'extra' => {
          'user_roles' => {
            'value' => []
          }
        }
      }.with_indifferent_access

      create(:admin_role, name: 'management', resource_id: 'be91dffe-b6bcb')
      admin_user = described_class.from_omniauth(auth_hash)

      expect(admin_user.roles).to be_empty
    end

    it 'ignores roles not included in set defaults' do
      create(:admin_role, name: 'read', resource_id: 'fe91dffe-sdf7s')
      admin_user = described_class.from_omniauth(auth_hash)

      expect(admin_user.roles).to be_empty
    end
  end

  describe '.roles_from' do
    it 'returns no roles if no roles set in auth hash' do
      auth_hash = {
        'provider' => :azure_ad_auth,
        'uid' => '1111-111-11-1',
        'credentials' => jwt,
        'extra' => {
          'user_roles' => {
            'value' => []
          }
        }
      }.with_indifferent_access

      create(:admin_role, name: 'management', resource_id: 'be91dffe-b6bcb')

      expect(described_class.roles_from(auth_hash)).to be_empty
    end

    it 'returns a role if its set in auth hash' do
      management = create(:admin_role, name: 'management', resource_id: 'be91dffe-b6bcb')

      expect(described_class.roles_from(auth_hash)).to contain_exactly(management)
    end

    it 'ignores roles not included in set defaults' do
      create(:admin_role, name: 'read', resource_id: 'fe91dffe-sdf7s')

      expect(described_class.roles_from(auth_hash)).to be_empty
    end
  end
end
