require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  describe 'GET #show' do
    context 'when courses are present' do
      it 'responds with success' do
        create(:course, :maths)

        get :show, params: { id: 'maths' }

        expect(response).to be_successful
      end
    end

    context 'when no courses are present' do
      it 'returns to /task-lists page' do
        get :show, params: { id: 'maths' }

        expect(response).to redirect_to task_list_path
      end
    end
  end
end
