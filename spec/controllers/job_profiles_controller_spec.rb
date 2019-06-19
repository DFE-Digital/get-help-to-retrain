require 'rails_helper'

RSpec.describe JobProfilesController, type: :controller do
  describe '#show' do
    context 'when a job profile exists' do
      let!(:job_profile) { create(:job_profile, slug: 'test') }

      it 'responds with 200' do
        get :show, params: { id: 'test' }

        expect(response).to be_successful
      end
    end

    context 'when a job profile does not exist' do
      it 'responds with 200' do
        get :show, params: { id: 'test' }

        expect(response).to be_successful
      end

      it 'does not raise an error' do
        expect {
          get :show, params: { id: 'test' }
        }.not_to raise_error
      end
    end
  end
end
