require 'rails_helper'

RSpec.describe 'routes for Job Profiles', type: :routing do
  it 'successfully routes to job_profiles#show' do
    job_profile = build(:job_profile)

    expect(get(job_profile_path(job_profile.slug))).to route_to(controller: 'job_profiles', action: 'show', id: job_profile.slug)
  end

  it 'successfully routes to job_profiles#destroy' do
    job_profile = build(:job_profile)

    expect(delete(job_profile_path(job_profile.slug))).to route_to(controller: 'job_profiles', action: 'destroy', id: job_profile.slug)
  end

  context 'with action_plan feature enabled' do
    before do
      enable_feature! :action_plan
    end

    it 'successfully routes to job_profiles#target' do
      job_profile = build(:job_profile)

      expect(post(target_job_profile_path(job_profile.slug))).to route_to(controller: 'job_profiles', action: 'target', id: job_profile.slug)
    end
  end

  context 'with action_plan feature disabled' do
    before do
      disable_feature! :action_plan
    end

    it 'does not root to job_profiles#target' do
      job_profile = build(:job_profile)

      expect(post(target_job_profile_path(job_profile.slug))).not_to be_routable
    end
  end
end
