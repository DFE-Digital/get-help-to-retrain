module QuestionHelper
  def action_plan_or_questions_path
    questions_path ||
      action_plan_path
  end

  def job_hunting_questions
    job_hunting_questions_path if user_session.job_hunting.nil?
  end

  def training_questions
    training_questions_path if user_session.training.nil?
  end

  def it_training_questions
    it_training_questions_path if user_session.it_training.nil?
  end

  def progression_indicator(step:)
    return unless questions_path

    content_tag(
      :span,
      "Step #{step} of 3",
      class: 'govuk-caption-xl'
    )
  end

  def questions_path
    training_questions ||
      it_training_questions ||
      job_hunting_questions
  end
end
