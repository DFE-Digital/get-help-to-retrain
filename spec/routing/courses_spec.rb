require 'rails_helper'

RSpec.describe 'routes for Courses', type: :routing do
  it 'successfully routes to pages#maths_overview' do
    expect(get(maths_course_overview_path)).to route_to('pages#maths_overview')
  end

  it 'successfully routes to pages#english_overview' do
    expect(get(english_course_overview_path)).to route_to('pages#english_overview')
  end

  it 'successfully routes to pages#training_hub' do
    expect(get(training_hub_path)).to route_to('pages#training_hub')
  end
end
