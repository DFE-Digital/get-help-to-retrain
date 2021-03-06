require 'rails_helper'

RSpec.describe FeedbackSurvey do
  it 'sets value to true if page useful is yes' do
    feedback_survey = create(:feedback_survey, page_useful: 'yes', url: 'example.com')
    expect(feedback_survey).to be_yes
  end

  it 'sets value to false if page useful is no' do
    feedback_survey = create(:feedback_survey, page_useful: 'no', url: 'example.com')
    expect(feedback_survey).to be_no
  end

  it 'rejects other values for page useful' do
    expect { create(:feedback_survey, page_useful: 'I donno', url: 'example.com') }.to raise_exception(ArgumentError)
  end
end
