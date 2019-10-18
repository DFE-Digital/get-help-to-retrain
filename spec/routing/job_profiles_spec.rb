require 'rails_helper'

RSpec.describe 'routes for Job Profiles', type: :routing do
  it 'successfully routes to job_profiles#show' do
    expect(get('/job-profiles/fishy')).to route_to(controller: 'job_profiles', action: 'show', id: 'fishy')
  end

  it 'successfully routes to job_profiles#destroy' do
    expect(delete('/job-profiles/fishy')).to route_to(controller: 'job_profiles', action: 'destroy', id: 'fishy')
  end

  context 'with action_plan feature enabled' do
    before do
      enable_feature! :action_plan
    end

    it 'successfully routes to job_profiles#target' do
      expect(post('/job-profiles/fishy/target')).to route_to(controller: 'job_profiles', action: 'target', id: 'fishy')
    end
  end

  context 'with action_plan feature disabled' do
    before do
      disable_feature! :action_plan
    end

    it 'does not root to job_profiles#target' do
      expect(post('/job-profiles/fishy/target')).not_to be_routable
    end
  end
end
