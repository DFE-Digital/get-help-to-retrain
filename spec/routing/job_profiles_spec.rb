require 'rails_helper'

RSpec.describe 'routes for Job Profiles', type: :routing do
  it 'successfully routes to job_profiles#show' do
    expect(get('/job-profiles/fishy')).to route_to(controller: 'job_profiles', action: 'show', id: 'fishy')
  end

  it 'successfully routes to job_profiles#destroy' do
    expect(delete('/job-profiles/fishy')).to route_to(controller: 'job_profiles', action: 'destroy', id: 'fishy')
  end

  it 'successfully routes to job_profiles#target' do
    expect(post('/job-profiles/fishy/target')).to route_to(controller: 'job_profiles', action: 'target', id: 'fishy')
  end
end
