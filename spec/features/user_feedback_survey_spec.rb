require 'rails_helper'

RSpec.feature 'User Feedback In Page Survey' do
  background do
    fill_pid_form
  end

  scenario 'User gets a thank you message when clicking yes', :js do
    answer_yes

    expect(page).to have_text('Thank you for your feedback')
  end

  scenario 'Page helpful survey is persisted when answering yes', :js do
    answer_yes

    click_on('Check your existing skills')

    expect(FeedbackSurvey.first.attributes).to include(
      'page_useful' => 'yes',
      'url' => /steps/
    )
  end

  scenario 'User sees the feedback survey when clicking no', :js do
    answer_no

    expect(page).to have_text('How should we improve this page?')
  end

  scenario 'User can close the feedback survey', :js do
    answer_no
    click_on('close')

    expect(page).not_to have_text('How should we improve this page?')
  end

  scenario 'User gets a thank you message after submitting survey', :js do
    answer_no
    click_on('Send message')

    expect(page).to have_text('Thank you for your feedback')
  end

  scenario 'Page not helpful survey is persisted when answering no', :js do
    answer_no
    fill_in('message', with: 'Page was not useful')
    click_on('Send message')
    click_on('Check your existing skills')

    expect(FeedbackSurvey.first.attributes).to include(
      'message' => 'Page was not useful',
      'page_useful' => 'no',
      'url' => /steps/
    )
  end

  def answer_yes
    visit(task_list_path)
    click_on('Yes')
  end

  def answer_no
    visit(task_list_path)
    click_on('No')
  end
end
