require 'rails_helper'

RSpec.feature 'Questions' do
  background do
    enable_feature! :action_plan
  end

  scenario 'Shows list of unselected training options' do
    visit(training_questions_path)

    expect(page).not_to have_selector('input[checked="checked"]')
  end

  scenario 'If user selects training options, options are persisted if user revisits page' do
    visit(training_questions_path)
    check('I need to improve my English skills', allow_label_click: true)
    check('I need to improve my maths skills', allow_label_click: true)
    click_on('Continue')
    visit(training_questions_path)

    expect(page).to have_selector('input[checked="checked"]', count: 2)
  end

  scenario 'Shows list of unselected job hunting options' do
    visit(job_hunting_questions_path)

    expect(page).not_to have_selector('input[checked="checked"]')
  end

  scenario 'If user selects job hunting options, options are persisted if user revisits page' do
    visit(job_hunting_questions_path)
    check('I want advice on creating or updating a CV', allow_label_click: true)
    check('I want advice on preparing for interviews', allow_label_click: true)
    click_on('Continue')
    visit(job_hunting_questions_path)

    expect(page).to have_selector('input[checked="checked"]', count: 2)
  end
end
