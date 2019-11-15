require 'rails_helper'

RSpec.describe 'routes for action plan', type: :routing do
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
