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

  describe '#from_omniauth' do
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

  describe '#roles' do
    it 'returns no roles if no roles given' do
      expect(admin_user.roles).to be_empty
    end

    it 'sets roles mask to nil if no roles given' do
      expect(admin_user.roles_mask).to be_nil
    end

    it 'returns a role if one role given' do
      admin_user.roles = ['manager']
      expect(admin_user.roles).to contain_exactly('manager')
    end

    it 'sets roles mask if one role given' do
      admin_user.roles = ['manager']
      expect(admin_user.roles_mask).to eq(1)
    end

    it 'returns roles if multiple roles given' do
      admin_user.roles = %w[write manager]
      expect(admin_user.roles).to contain_exactly('write', 'manager')
    end

    it 'sets roles mask if multiple roles given' do
      admin_user.roles = %w[write manager]
      expect(admin_user.roles_mask).to eq(3)
    end

    it 'overwrites roles if already set' do
      admin_user.roles = %w[write manager]
      admin_user.roles = %w[read manager]

      expect(admin_user.roles).to contain_exactly('read', 'manager')
    end

    it 'overwrites roles mask if already set' do
      admin_user.roles = %w[write manager]
      admin_user.roles = %w[read manager]

      expect(admin_user.roles_mask).to eq(5)
    end

    it 'returns no roles if non existing roles given' do
      admin_user.roles = %w[captain]
      expect(admin_user.roles).to be_empty
    end

    it 'sets roles mask to nil if non existing roles given' do
      admin_user.roles = %w[captain]
      expect(admin_user.roles_mask).to be_zero
    end

    it 'ignores non existing roles' do
      admin_user.roles = %w[captain manager]
      expect(admin_user.roles).to contain_exactly('manager')
    end
  end

  describe '.with_roles' do
    it 'returns all admin users with a set role' do
      admin1 = create(:admin_user, roles: ['manager'])
      admin2 = create(:admin_user, roles: ['write'])
      admin3 = create(:admin_user, roles: ['manager', 'write'])

      expect(described_class.with_role('write')).to contain_exactly(admin2, admin3)
    end

    it 'returns no admin users if role is not present' do
      create(:admin_user, roles: ['manager'])
      expect(described_class.with_role('write')).to be_empty
    end
  end
end
