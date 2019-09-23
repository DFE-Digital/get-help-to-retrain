require 'rails_helper'

RSpec.describe 'routes for Job Profiles', type: :routing do
  it 'successfully routes to job_profiles#show' do
    job_profile = create(:job_profile)

    expect(get(job_profile_path(job_profile.slug))).to route_to(controller: 'job_profiles', action: 'show', id: job_profile.slug)
  end

  it 'does not route to job_profiles#destroy' do
    job_profile = create(:job_profile)

    expect(delete(job_profile_path(job_profile.slug))).not_to route_to(controller: 'job_profiles', action: 'destroy', id: job_profile.slug)
  end

  context 'when :skills_builder_v2 feature is ON but skills_builder is OFF' do
    before do
      enable_feature! :skills_builder_v2
    end

    it 'successfully routes to job_profiles#show' do
      job_profile = create(:job_profile)

      expect(get(job_profile_path(job_profile.slug))).to route_to(controller: 'job_profiles', action: 'show', id: job_profile.slug)
    end

    it 'successfully routes to job_profiles#destroy' do
      job_profile = create(:job_profile)

      expect(delete(job_profile_path(job_profile.slug))).to route_to(controller: 'job_profiles', action: 'destroy', id: job_profile.slug)
    end
  end
end
