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
    click_on('Find and apply to training courses near you ')

    expect(page).to have_text('Find and apply to a training course near you')
  end

  scenario 'User finds ouy next steps' do
    visit(task_list_path)
    click_on('Find out what you can do next')

    expect(page).to have_text('Get advice and help in your search for a new role.')
  end
end
