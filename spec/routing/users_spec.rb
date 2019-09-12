require 'rails_helper'

RSpec.describe 'routes for Users', type: :routing do
  before do
    disable_feature! :user_authentication
  end

  it 'does not route to users#new' do
    expect(get(save_your_results_path)).not_to route_to('users#new')
  end

  it 'does not route to users#show' do
    expect(get(link_sent_path)).not_to route_to('users#show')
  end

  it 'does not route to passwordless/sessions#show' do
    expect(get(token_sign_in_path(token: 'token'))).not_to route_to('passwordless/sessions#show')
  end

  context 'when :user_authentication feature is ON' do
    before do
      enable_feature! :user_authentication
    end

    it 'successfully routes to users#new' do
      expect(get(save_your_results_path)).to route_to('users#new')
    end

    it 'successfully routes to users#show' do
      expect(get(link_sent_path)).to route_to('users#show')
    end

    it 'successfully routes to passwordless/sessions#show' do
      expect(get(token_sign_in_path(token: 'token'))).to route_to(
        controller: 'passwordless/sessions',
        action: 'show',
        authenticatable: 'user',
        token: 'token'
      )
    end
  end
end