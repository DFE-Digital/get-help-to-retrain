require 'rails_helper'

RSpec.describe 'routes for Location Eligibility', type: :routing do
  context 'when :location_eligibility feature is ON' do
    before do
      enable_feature! :location_eligibility
    end

    it 'successfully routes to pages#location_eligibility' do
      expect(get(location_eligibility_path)).to route_to('pages#location_eligibility')
    end

    it 'successfully routes to pages#location_ineligible' do
      expect(get(location_ineligible_path)).to route_to('pages#location_ineligible')
    end

    it 'successfully routes to errors#postcode_search_error' do
      expect(get(postcode_search_error_path)).to route_to('errors#postcode_search_error')
    end
  end

  context 'when :location_eligibility feature is OFF' do
    before do
      disable_feature! :location_eligibility
    end

    it 'does not route to pages#location_eligibility' do
      expect(get(location_eligibility_path)).not_to be_routable
    end

    it 'does not route to pages#location_ineligible' do
      expect(get(location_ineligible_path)).not_to be_routable
    end

    it 'does not route to errors#postcode_search_error' do
      expect(get(postcode_search_error_path)).not_to be_routable
    end
  end
end
