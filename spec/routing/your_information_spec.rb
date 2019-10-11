require 'rails_helper'

RSpec.describe 'routes for Your information page', type: :routing do
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
end
