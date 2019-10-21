require 'rails_helper'

RSpec.describe 'routes for action plan', type: :routing do
  context 'with action_plan feature enabled' do
    before do
      enable_feature! :action_plan
    end

    it 'successfully routes to pages#action_plan' do
      expect(get('/action-plan')).to route_to(controller: 'pages', action: 'action_plan')
    end
  end

  context 'with action_plan feature disabled' do
    before do
      disable_feature! :action_plan
    end

    it 'does not root to pages#action_plan' do
      expect(get('/action-plan')).not_to be_routable
    end
  end
end