require 'rails_helper'

RSpec.describe 'routes for job vacancies', type: :routing do
  context 'with action_plan feature enabled' do
    before do
      enable_feature! :action_plan
    end

    it 'successfully routes to job_vacancies#index' do
      expect(get('/jobs-near-me')).to route_to(controller: 'job_vacancies', action: 'index')
    end
  end

  context 'with action_plan feature disabled' do
    before do
      disable_feature! :action_plan
    end

    it 'does not root to job_vacancies#index' do
      expect(get('/jobs-near-me')).not_to be_routable
    end
  end
end
