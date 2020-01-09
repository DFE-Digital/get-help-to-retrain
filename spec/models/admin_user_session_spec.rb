require 'rails_helper'

RSpec.describe AdminUserSession do
  subject(:user_session) { described_class.new(session) }

  let(:session) { {} }

  describe '#user_id' do
    it 'returns the value for :user_id key if set' do
      user_session.user_id = '1111-111-1'

      expect(user_session.user_id).to eq '1111-111-1'
    end

    it 'returns nil if :user_id key if not set' do
      expect(user_session.user_id).to be_nil
    end
  end
end
