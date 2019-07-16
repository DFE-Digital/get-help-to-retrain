require 'rails_helper'

RSpec.feature 'Tasks List', type: :feature do
  scenario 'User navigates to task list page' do
    visit(root_path)
    click_on('Start now')

    expect(page).to have_text('Check what you need to do to retrain for another job')
  end

  scenario 'User checks their existing skills' do
    visit(task_list_path)
    click_on('Check your existing skills')

    expect(page).to have_text('Check your existing skills')
  end

  scenario 'User explores their occupation' do
    visit(task_list_path)
    click_on('Search for the types of jobs you could retrain to do')

    expect(page).to have_text('Explore occupations')
  end

  scenario 'User finds a training course' do
    visit(task_list_path)
    click_on('Find a training course')

    expect(page).to have_text('Find and apply to a training course near you')
  end

  scenario 'User finds ouy next steps' do
    visit(task_list_path)
    click_on('Get more support to help you on your new career path')

    expect(page).to have_text('Get advice and help in your search for a new role.')
  end

  scenario 'Smart survey link is present on the top banner' do
    visit(task_list_path)

    link = find_link('feedback')

    expect([link[:href], link[:target]]).to eq(
      [
        'https://www.smartsurvey.co.uk/s/get-help-to-retrain/',
        '_blank'
      ]
    )
  end

  scenario 'Smart survey link is present under Help improve this service section' do
    visit(task_list_path)

    link = find_link('Take a quick survey and tell us about your experience ')

    expect([link[:href], link[:target]]).to eq(
      [
        'https://www.smartsurvey.co.uk/s/get-help-to-retrain/',
        '_blank'
      ]
    )
  end
end
