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

  it 'does not route to users#sign_in' do
    expect(post(sign_in_path)).not_to route_to('users#sign_in')
  end

  it 'does not route to users#registration_send_email_again' do
    expect(post(email_sent_again_path)).not_to route_to('users#registration_send_email_again')
  end

  it 'does not route to users#sign_in_send_email_again' do
    expect(post(link_sent_again_path)).not_to route_to('users#sign_in_send_email_again')
  end

  it 'does not route to passwordless/sessions#show' do
    expect(get(token_sign_in_path(token: 'token'))).not_to route_to('passwordless/sessions#show')
  end

  it 'does not route to users#link_expired' do
    expect(get(link_expired_path)).not_to route_to('users#link_expired')
  end

  it 'does not route to users#return_to_saved_results' do
    expect(get(return_to_saved_results_path)).not_to route_to('users#return_to_saved_results')
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

    it 'successfully routes to users#sign_in' do
      expect(post(sign_in_path)).to route_to('users#sign_in')
    end

    it 'successfully routes to passwordless/sessions#show' do
      expect(get(token_sign_in_path(token: 'token'))).to route_to(
        controller: 'passwordless/sessions',
        action: 'show',
        authenticatable: 'user',
        token: 'token'
      )
    end

    it 'successfully routes users#registration_send_email_again' do
      expect(post(email_sent_again_path)).to route_to('users#registration_send_email_again')
    end

    it 'successfully routes users#sign_in_send_email_again' do
      expect(post(link_sent_again_path)).to route_to('users#sign_in_send_email_again')
    end

    it 'successfully routes to users#link_expired' do
      expect(get(link_expired_path)).to route_to('users#link_expired')
    end

    it 'successfully routes to users#return_to_saved_results' do
      expect(get(return_to_saved_results_path)).to route_to('users#return_to_saved_results')
    end
  end
end
