require 'rails_helper'

RSpec.describe 'routes for action plan', type: :routing do
  context 'with action_plan feature enabled' do
    before do
      enable_feature! :action_plan
    end

    it 'successfully routes to pages#action_plan' do
      expect(get('/action-plan')).to route_to(controller: 'pages', action: 'action_plan')
    end

    it 'successfully routes to pages#offers_near_me' do
      expect(get('/offers-near-me')).to route_to(controller: 'pages', action: 'offers_near_me')
    end

    it 'successfully routes to errors#jobs_near_me_error' do
      expect(get('/jobs-near-me-error')).to route_to(controller: 'errors', action: 'jobs_near_me_error')
    end

    it 'successfully routes to questions#training' do
      expect(get('/training-questions')).to route_to(controller: 'questions', action: 'training')
    end

    it 'successfully routes to questions#jobs_hunting' do
      expect(get('/job-hunting-questions')).to route_to(controller: 'questions', action: 'job_hunting')
    end
  end

  context 'with action_plan feature disabled' do
    before do
      disable_feature! :action_plan
    end

    it 'does not route to pages#action_plan' do
      expect(get('/action-plan')).not_to be_routable
    end

    it 'does not route to pages#offers_near_me' do
      expect(get('/offers-near-me')).not_to be_routable
    end

    it 'does not route to errors#jobs_near_me_error' do
      expect(get('/jobs-near-me-error')).not_to be_routable
    end

    it 'does not route to questions#training' do
      expect(get('/training-questions')).not_to be_routable
    end

    it 'does not route to questions#job_hunting_questions' do
      expect(get('/job-hunting-questions')).not_to be_routable
    end
  end
end
