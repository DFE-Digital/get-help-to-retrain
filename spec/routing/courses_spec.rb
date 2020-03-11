require 'rails_helper'

RSpec.describe 'routes for Courses', type: :routing do
  xit 'successfully routes to courses#index for existing course' do
    create(:course, :maths)

    expect(get('/courses/maths')).to route_to(controller: 'courses', action: 'index', topic_id: 'maths')
  end

  xit 'does not route to courses#index for non-existing course' do
    expect(get('/courses/history')).not_to be_routable
  end

  context 'when csv_courses flag is OFF' do
    before do
      disable_feature!(:csv_courses)
    end

    xit 'does not route to courses#show' do
      course_lookup = create(:course_lookup, subject: 'english')

      expect(get("/courses/english/#{course_lookup.opportunity.id}")).not_to be_routable
    end
  end

  context 'when csv_courses flag is ON' do
    before do
      enable_feature!(:csv_courses)
    end

    xit 'does not route to courses#show' do
      course_lookup = create(:course_lookup, subject: 'english')

      expect(
        get("/courses/english/#{course_lookup.opportunity.id}")
      ).to route_to(controller: 'courses', action: 'show', opportunity_id: course_lookup.opportunity.id.to_s, topic_id: 'english')
    end
  end
end
