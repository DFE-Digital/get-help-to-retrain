require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  describe 'GET #index' do
    context 'when an existing course topic is accessed' do
      it 'responds with success' do
        create(:course, :maths)

        get :index, params: { topic_id: 'maths' }

        expect(response).to be_successful
      end
    end

    context 'when no courses are present' do
      it 'returns to /task-lists page' do
        get :index, params: { topic_id: 'maths' }

        expect(response).to redirect_to task_list_path
      end
    end
  end
end
