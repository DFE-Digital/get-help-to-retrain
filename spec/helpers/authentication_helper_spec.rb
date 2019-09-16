require 'rails_helper'

RSpec.describe AuthenticationHelper do
  describe '.user_with_validation' do
    it 'return instance of user' do
      expect(helper.user_with_validation).to be_an_instance_of(User)
    end

    it 'returns correct validation if supplied' do
      flash[:error] = ['Some validation error']
      expect(helper.user_with_validation.errors[:email]).to contain_exactly('Some validation error')
    end
  end
end
