require 'rails_helper'

RSpec.describe 'routes for Skills', type: :routing do
  context 'when :skills_builder feature is ON' do
    before do
      enable_feature! :skills_builder
    end

    it 'successfully routes to job_profiles_skills#index' do
      job_profile = create(:job_profile)
      expect(get(job_profile_skills_path(job_profile.slug))).to route_to(controller: 'job_profiles_skills', action: 'index', job_profile_id: job_profile.slug)
    end

    it 'successfully routes to skills#index' do
      expect(get(skills_path)).to route_to('skills#index')
    end
  end

  context 'when :skills_builder_v2 feature is ON but :skills_builder is OFF' do
    before do
      disable_feature! :skills_builder
      enable_feature! :skills_builder_v2
    end

    it 'successfully routes to job_profiles_skills#index' do
      job_profile = create(:job_profile)
      expect(get(job_profile_skills_path(job_profile.slug))).to route_to(controller: 'job_profiles_skills', action: 'index', job_profile_id: job_profile.slug)
    end
  end

  context 'when :skills_builder feature is OFF' do
    before do
      disable_feature! :skills_builder
    end

    it 'successfully routes to job_profiles/skills#index' do
      job_profile = create(:job_profile)
      expect(get(job_profile_skills_path(job_profile.slug))).to route_to(controller: 'skills', action: 'index', job_profile_id: job_profile.slug)
    end

    it 'does not route to skills#index' do
      expect(get(skills_path)).not_to be_routable
    end
  end
end
