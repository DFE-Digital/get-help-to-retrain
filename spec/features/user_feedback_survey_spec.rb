require 'rails_helper'

RSpec.feature 'User Feedback In Page Survey' do
  scenario 'Feedback form is not present when disabled in configuration' do
    allow(Rails.configuration).to receive(:smart_survey_user_feedback_link).and_return(nil)

    visit(root_path)

    expect(page).not_to have_text('Is this page useful?')
  end

  scenario 'User gets a thank you message when clicking yes', :js do
    visit(root_path)

    click_on('Accept cookies')

    find('#answer-yes').click

    expect(page).to have_text('Thank you for your feedback')
  end

  scenario 'User gets the SmartSurvey iframe when clicking no', :js do
    visit(root_path)

    click_on('Accept cookies')

    find('#answer-no').click

    expect(page).to have_css('iframe#ss-embed-frame')
  end
end
