class FeedbackSurveysController < ApplicationController
  def create
    FeedbackSurvey.new(feedback_survey_params).save
  end

  private

  def feedback_survey_params
    params.permit(:page_useful, :message)
  end
end
