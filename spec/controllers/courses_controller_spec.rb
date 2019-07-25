require 'rails_helper'

# TODO: move this to spec/routes
RSpec.describe CoursesController, type: :controller do
  describe 'GET #index' do
    before { enable_feature! :course_directory }

    context 'when an existing course topic is accessed' do
      it 'responds with success' do
        create(:course, :maths)

        get :index, params: { topic_id: 'maths' }

        expect(response).to be_successful
      end
    end

    context 'when a non-existing course topic is accessed' do
      it 'is not routable' do
        expect(get: :index, params: { topic_id: 'history' }).not_to be_routable # rubocop:disable RSpec/ExpectActual
      end
    end

    context 'when course directory feature is disabled' do
      before { disable_feature! :course_directory }

      it 'returns to /task-lists page' do
        get :index, params: { topic_id: 'maths' }

        expect(response).to redirect_to task_list_path
      end
    end
  end
end
