require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  describe 'GET #location_eligibility' do
    before { enable_feature! :location_eligibility }

    it 'persists a valid postcode in the session' do
      get '/location-eligibility', params: { postcode: 'NW6 1JF' }

      expect(session[:postcode]).to eq 'NW6 1JF'
    end

    it 'does not persist an invalid postcode' do
      get '/location-eligibility', params: { postcode: 'NNN' }

      expect(session[:postcode]).to be nil
    end
  end
end
