require 'rails_helper'

RSpec.feature 'User sign in' do
  before do
    enable_feature!(:user_authentication, :skills_builder_v2)
  end

  scenario 'User gets relevant messaging if no email is entered' do
    visit(root_path)
    click_on('Send a link')

    expect(page).to have_text(/Enter an email address/)
  end

  scenario 'User gets relevant messaging if invalid email is entered' do
    visit(root_path)
    fill_in('email', with: 'wrong email')
    click_on('Send a link')

    expect(page).to have_text(/Enter a valid email address/)
  end

  scenario 'User does not see validation error if they continue on from page' do
    visit(root_path)
    fill_in('email', with: 'wrong email')
    click_on('Send a link')
    click_on('Start')

    expect(page).not_to have_text(/Enter a valid email address/)
  end
end
