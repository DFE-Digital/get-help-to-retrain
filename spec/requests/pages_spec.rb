require 'rails_helper'

RSpec.describe 'Pages', type: :request do
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
