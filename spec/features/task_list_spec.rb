require 'rails_helper'

RSpec.describe 'Tasks List', type: :feature do
  it 'User navigates to task list page' do
    visit(root_path)
    click_on('Start now')

    expect(page).to have_text('Check what you need to do to retrain for another job')
  end

  it 'User finds ouy next steps' do
    visit(task_list_path)
    click_on('Find out what you can do next')

    expect(page).to have_text('Get advice and help in your search for a new role.')
  end
end
