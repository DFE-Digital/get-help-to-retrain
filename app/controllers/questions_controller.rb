class QuestionsController < ApplicationController
  before_action :redirect_unless_target_job

  AVAILABLE_OPTIONS = {
    training: %w[english_skills math_skills],
    job_hunting: %w[cv cover_letter interviews]
  }.freeze

  def training_answers
    user_session.training = questions_params[:training] || []

    track_selections(
      :training,
      selected: selected_options_for(:training),
      unselected: unselected_options_for(:training)
    )

    redirect_to helpers.job_hunting_questions || action_plan_path
  end

  def job_hunting_answers
    user_session.job_hunting = questions_params[:job_hunting] || []

    track_selections(
      :job_hunting,
      selected: selected_options_for(:job_hunting),
      unselected: unselected_options_for(:job_hunting)
    )

    redirect_to action_plan_path
  end

  private

  def selected_options_for(section)
    {
      label: I18n.t(section, action: 'Ticked', scope: 'events'),
      values: user_answers_for(section)
    }
  end

  def unselected_options_for(section)
    {
      label: I18n.t(section, action: 'Unticked', scope: 'events'),
      values: AVAILABLE_OPTIONS[section] - user_answers_for(section)
    }
  end

  def questions_params
    params.permit(
      training: [],
      job_hunting: []
    )
  end

  def user_answers_for(section)
    questions_params[section] || []
  end
end
