require 'rails_helper'

RSpec.feature 'User Feedback In Page Survey' do
  scenario 'User gets a thank you message when clicking yes', :js do
    visit(root_path)

    click_on('Accept cookies')

    find('#answer-yes').click

    expect(page).to have_text('Thank you for your feedback')
  end

  xscenario 'User gets the SmartSurvey iframe when clicking no', :js do
    visit(root_path)

    click_on('Accept cookies')

    find('#answer-no').click

    expect(page).to have_css('iframe#ss-embed-frame')
  end
end
