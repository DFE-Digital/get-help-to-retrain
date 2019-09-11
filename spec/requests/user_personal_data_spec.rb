require 'rails_helper'

RSpec.describe 'User personal data', type: :request do
  describe 'POST user_personal_data#create' do
    before do
      enable_feature! :user_personal_data
    end

    let(:params) {
      {
        user_personal_data: {
          first_name: 'John',
          last_name: 'Mayer',
          postcode: 'NW6 1JJ',
          gender: 'male',
          birth_day: '1',
          birth_month: '1',
          birth_year: '2014'
        }
      }
    }

    it 'creates the resource' do
      expect {
        post your_information_path, params: params
      }.to change(UserPersonalData, :count).from(0).to(1)
    end

    it 'stores the correct data' do
      post your_information_path, params: params

      expect(UserPersonalData.last).to have_attributes(
        first_name: 'John',
        last_name: 'Mayer',
        postcode: 'NW6 1JJ',
        gender: 'male',
        dob: Date.new(2014, 1, 1)
      )
    end
  end
end
