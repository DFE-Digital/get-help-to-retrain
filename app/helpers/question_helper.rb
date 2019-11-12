module QuestionHelper
  def job_hunting_questions
    job_hunting_questions_path unless user_session.job_hunting.any?
  end

  def training_questions
    training_questions_path unless user_session.training.any?
  end
end
