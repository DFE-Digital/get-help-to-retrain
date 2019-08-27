require 'rails_helper'

RSpec.describe 'routes for Skills Matcher', type: :routing do
  context 'when :skills_builder feature is ON' do
    before do
      enable_feature! :skills_builder
    end

    it 'successfully routes to skills_matcher#index' do
      expect(get(skills_matcher_index_path)).to route_to(controller: 'skills_matcher', action: 'index')
    end
  end

  context 'when :skills_builder_v2 feature is ON but skills_builder is OFF' do
    before do
      disable_feature! :skills_builder
      enable_feature! :skills_builder_v2
    end

    it 'successfully routes to skills_matcher#index' do
      expect(get(skills_matcher_index_path)).to route_to(controller: 'skills_matcher', action: 'index')
    end
  end

  context 'when :skills_builder feature is OFF' do
    before do
      disable_feature! :skills_builder
    end

    it 'does not route to skills_matcher#index' do
      expect(get(skills_matcher_index_path)).not_to be_routable
    end
  end
end
