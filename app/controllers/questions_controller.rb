class QuestionsController < ApplicationController
  def training_answers
    # user_session.questions = questions_params[:training]
    redirect_to action_plan_path
  end

  private

  def questions_params
    params.permit(
      training: []
    )
  end
end
