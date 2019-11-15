require 'rails_helper'

RSpec.describe 'routes for Courses', type: :routing do
  it 'successfully routes to courses#index for existing course' do
    create(:course, :maths)

    expect(get('/courses/maths')).to route_to(controller: 'courses', action: 'index', topic_id: 'maths')
  end

  it 'does not route to courses#index for non-existing course' do
    expect(get('/courses/history')).not_to be_routable
  end
end
