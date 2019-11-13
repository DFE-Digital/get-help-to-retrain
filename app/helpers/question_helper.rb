module QuestionHelper
  def action_plan_or_questions_path
    training_questions ||
      job_hunting_questions ||
      action_plan_path
  end

  def job_hunting_questions
    job_hunting_questions_path if user_session.job_hunting.nil?
  end

  def training_questions
    training_questions_path if user_session.training.nil?
  end
end
