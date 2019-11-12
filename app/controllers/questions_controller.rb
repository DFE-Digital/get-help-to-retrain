class QuestionsController < ApplicationController
  def training
    @referer = request.referer && URI(request.referer).path == action_plan_path
  end

  def training_answers
    user_session.training = questions_params[:training]
    redirect_to action_path_or_job_hunting_path
  end

  def job_hunting_answers
    user_session.job_hunting = questions_params[:job_hunting]
    redirect_to action_plan_path
  end

  private

  def questions_params
    params.permit(
      :action_plan_referer,
      training: [],
      job_hunting: []
    )
  end

  def action_path_or_job_hunting_path
    return action_plan_path if questions_params[:action_plan_referer] == 'true'

    helpers.job_hunting_questions || action_plan_path
  end
end
