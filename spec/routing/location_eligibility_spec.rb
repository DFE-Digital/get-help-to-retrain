require 'rails_helper'

RSpec.describe 'routes for Location Eligibility', type: :routing do
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
