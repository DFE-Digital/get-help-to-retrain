require 'rails_helper'

RSpec.feature 'Cookies Banner', type: :feature do
  scenario 'User sees cookies modal with two options' do
    visit(root_path)

    ['Accept all cookies', 'Accept necessary cookies only'].each do |content|
      expect(page).to have_button(content)
    end
  end

  scenario 'User does not see cookies modal on cookies policy page' do
    visit(root_path)
    click_on('cookies policy')

    ['Accept all cookies', 'Accept necessary cookies only'].each do |content|
      expect(page).not_to have_button(content)
    end
  end

  scenario 'User does not see cookies modal when they accept all cookies' do
    visit(root_path)
    click_on('Accept all cookies')

    ['Accept all cookies', 'Accept necessary cookies only'].each do |content|
      expect(page).not_to have_button(content)
    end
  end

  scenario 'User does not see cookies modal when they accept necessary cookies only' do
    visit(root_path)
    click_on('Accept necessary cookies only')

    ['Accept all cookies', 'Accept necessary cookies only'].each do |content|
      expect(page).not_to have_button(content)
    end
  end

  scenario 'User is redirected to same page they saw cookies modal on' do
    visit(your_information_path)
    click_on('Accept necessary cookies only')

    expect(page).to have_current_path(your_information_path)
  end
end
