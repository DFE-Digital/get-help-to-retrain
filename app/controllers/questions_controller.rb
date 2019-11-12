class QuestionsController < ApplicationController
  def training_answers
    user_session.training = questions_params[:training] || []
    redirect_to helpers.job_hunting_questions || action_plan_path
  end

  def job_hunting_answers
    user_session.job_hunting = questions_params[:job_hunting] || []
    redirect_to action_plan_path
  end

  private

  def questions_params
    params.permit(
      training: [],
      job_hunting: []
    )
  end
end
