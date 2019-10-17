require 'rails_helper'

RSpec.describe 'routes for Skills', type: :routing do
  it 'successfully routes to job_profiles_skills#index' do
    job_profile = create(:job_profile)
    expect(get(job_profile_skills_path(job_profile.slug))).to route_to(controller: 'job_profiles_skills', action: 'index', job_profile_id: job_profile.slug)
  end

  it 'successfully routes to skills#index' do
    expect(get(skills_path)).to route_to('skills#index')
  end
end
