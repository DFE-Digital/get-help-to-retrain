require 'rails_helper'

RSpec.describe 'routes for Skills Matcher', type: :routing do
  it 'successfully routes to skills_matcher#index' do
    expect(get(skills_matcher_index_path)).to route_to(controller: 'skills_matcher', action: 'index')
  end

  context 'when :skills_builder_v2 feature is ON but skills_builder is OFF' do
    before do
      enable_feature! :skills_builder_v2
    end

    it 'successfully routes to skills_matcher#index' do
      expect(get(skills_matcher_index_path)).to route_to(controller: 'skills_matcher', action: 'index')
    end
  end
end
