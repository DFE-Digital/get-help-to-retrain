require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  describe 'GET #location_eligibility' do
    it 'persists a valid postcode in the session' do
      get '/location-eligibility', params: { postcode: 'NW6 1JF' }

      expect(session[:postcode]).to eq 'NW6 1JF'
    end

    it 'does not persist an invalid postcode' do
      get '/location-eligibility', params: { postcode: 'NNN' }

      expect(session[:postcode]).to be nil
    end
  end

  describe 'GET #next_steps' do
    it 'presists next steps page on the session' do
      get next_steps_path

      expect(session[:visited_pages]).to eq(['next_steps'])
    end
  end

  describe 'GET #training_hub' do
    it 'presists next steps page on the session' do
      get training_hub_path

      expect(session[:visited_pages]).to eq(['training_hub'])
    end
  end
end
