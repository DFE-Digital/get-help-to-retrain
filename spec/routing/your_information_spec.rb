require 'rails_helper'

RSpec.describe 'routes for Your information page', type: :routing do
  it 'does not map user_personal_data#index' do
    expect(get(your_information_path)).not_to route_to('user_personal_data#index')
  end

  it 'does not map to user_personal_data#create' do
    expect(post(your_information_path)).not_to route_to('user_personal_data#create')
  end

  it 'does not route to user_personal_data#index' do
    expect(get(user_personal_data_path)).not_to route_to(controller: 'user_personal_data', action: 'index')
  end

  it 'does not route to user_personal_data#create' do
    expect(post(user_personal_data_path)).not_to route_to(controller: 'user_personal_data', action: 'create')
  end

  it 'does not route to user_personal_data#skip' do
    expect(get(skip_step_path)).not_to route_to(controller: 'user_personal_data', action: 'skip')
  end

  context 'when :user_personal_data feature is ON' do
    before do
      enable_feature! :user_personal_data
    end

    it 'successfully maps to user_personal_data#index' do
      expect(get(your_information_path)).to route_to('user_personal_data#index')
    end

    it 'successfully maps to user_personal_data#create' do
      expect(post(your_information_path)).to route_to('user_personal_data#create')
    end

    it 'successfully routes to user_personal_data#index' do
      expect(get(user_personal_data_path)).to route_to(controller: 'user_personal_data', action: 'index')
    end

    it 'successfully routes to user_personal_data#create' do
      expect(post(user_personal_data_path)).to route_to(controller: 'user_personal_data', action: 'create')
    end

    it 'successfully routes to user_personal_data#skip' do
      expect(get(skip_step_path)).to route_to(controller: 'user_personal_data', action: 'skip')
    end
  end
end
