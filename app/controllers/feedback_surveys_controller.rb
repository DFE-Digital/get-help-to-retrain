class FeedbackSurveysController < ApplicationController
  def create
    @survey = FeedbackSurvey.new(feedback_survey_params)
    render :show if @survey.save
  end

  private

  def feedback_survey_params
    params.permit(:page_useful, :message)
  end
end
