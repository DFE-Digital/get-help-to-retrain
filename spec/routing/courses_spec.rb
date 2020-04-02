require 'rails_helper'

RSpec.describe 'routes for Courses', type: :routing do
  it 'successfully routes to courses#index for existing course' do
    expect(get('/courses/maths')).to route_to(controller: 'courses', action: 'index', topic_id: 'maths')
  end

  it 'does not route to courses#index for non-existing course' do
    expect(get('/courses/history')).not_to be_routable
  end

  it 'does route to courses#show' do
    expect(
      get('/courses/english/111-11/222-2')
    ).to route_to(controller: 'courses', action: 'show', course_id: '111-11', course_run_id: '222-2', topic_id: 'english')
  end

  it 'does route to errors#courses_near_me_error' do
    expect(
      get('/courses-near-you-error')
    ).to route_to(controller: 'errors', action: 'courses_near_me_error')
  end
end
