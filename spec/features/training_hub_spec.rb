require 'rails_helper'

RSpec.feature 'Training Hub page', type: :feature do
  scenario 'User navigates to the training hub page' do
    visit(training_hub_path)

    expect(page).to have_text('Find training that boosts your job options')
  end

  scenario 'User proceeds with checking the benefits of doing a math course' do
    visit(training_hub_path)

    click_on('More information on maths courses')

    expect(page).to have_text('Benefits of doing a maths course')
  end

  scenario 'User clicks to finding a math course' do
    visit(training_hub_path)

    click_on('Find a maths course')

    expect(page).to have_text('Maths courses near me')
  end

  scenario 'User proceeds with checking the benefits of doing an English course' do
    visit(training_hub_path)

    click_on('More information on English courses')

    expect(page).to have_text('Benefits of doing an English course')
  end

  scenario 'User clicks to finding an English course' do
    visit(training_hub_path)

    click_on('Find an English course')

    expect(page).to have_text('English courses near me')
  end
end
