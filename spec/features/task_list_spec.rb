require 'rails_helper'

RSpec.describe 'Tasks List', type: :feature do
  it 'User navigates to task list page' do
    visit(root_path)
    click_on('Start now')

    expect(page).to have_text('Check what you need to do to retrain for another job')
  end

  it 'User finds a training course' do
    visit(task_list_path)
    click_on('Find and apply to training courses near you ')

    expect(page).to have_text('Find and apply to a training course near you')
  end

  it 'User finds ouy next steps' do
    visit(task_list_path)
    click_on('Find out what you can do next')

    expect(page).to have_text('Get advice and help in your search for a new role.')
  end
end
