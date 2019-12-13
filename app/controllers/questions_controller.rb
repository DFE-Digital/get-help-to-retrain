class QuestionsController < ApplicationController
  before_action :redirect_unless_target_job

  AVAILABLE_OPTIONS = {
    training: %w[english_skills math_skills],
    job_hunting: %w[cv cover_letter interviews],
    it_training: %w[computer_skills]
  }.freeze

  def training_answers
    user_session.training = questions_params[:training] || []

    track_selections(
      selected: selected_options_for('training'),
      unselected: unselected_options_for('training')
    )

    redirect_to helpers.it_training_questions || helpers.job_hunting_questions || action_plan_path
  end

  def it_training_answers
    user_session.it_training = questions_params[:it_training] || []

    track_selections(
      selected: selected_options_for('it_training'),
      unselected: unselected_options_for('it_training')
    )

    redirect_to helpers.job_hunting_questions || action_plan_path
  end

  def job_hunting_answers
    user_session.job_hunting = questions_params[:job_hunting] || []

    track_selections(
      selected: selected_options_for('job_hunting'),
      unselected: unselected_options_for('job_hunting')
    )

    redirect_to action_plan_path
  end

  private

  def selected_options_for(section)
    {
      key: "#{section}_ticked".to_sym,
      label: I18n.t(section, scope: 'events'),
      values: user_answers_for(section.to_sym)
    }
  end

  def unselected_options_for(section)
    {
      key: "#{section}_unticked".to_sym,
      label: I18n.t(section, scope: 'events'),
      values: AVAILABLE_OPTIONS[section.to_sym] - user_answers_for(section)
    }
  end

  def questions_params
    params.permit(
      training: [],
      job_hunting: [],
      it_training: []
    )
  end

  def user_answers_for(section)
    questions_params[section] || []
  end
end
