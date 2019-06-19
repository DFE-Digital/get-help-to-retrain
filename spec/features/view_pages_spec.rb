require 'rails_helper'

RSpec.describe 'View pages', type: :feature do
  it 'Navigate to home' do
    visit '/pages/home'

    expect(page).to have_text('Lorem')
  end
end
