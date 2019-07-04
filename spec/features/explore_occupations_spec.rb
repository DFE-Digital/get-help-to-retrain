require 'rails_helper'

RSpec.feature 'Explore Occupations', type: :feature do
  let!(:job_profile) do
    create(
      :job_profile,
      :with_html_content,
      name: 'Zombie Killer',
      categories: [
        create(:category, name: 'Apocalyptic services')
      ],
      skills: [
        create(:skill, name: 'the ability to work well with the deceased')
      ]
    )
  end

  scenario 'User explores their career through categories' do
    visit(explore_occupations_path)
    click_on('Apocalyptic services')
    click_on('Zombie Killer')

    expect(page).to have_text('the ability to work well with the deceased')
  end

  scenario 'User explores their occupations through search' do
    visit(explore_occupations_path)
    fill_in('name', with: 'Zombie Killer')
    find('.search-button').click
    click_on('Zombie Killer')

    expect(page).to have_text('the ability to work well with the deceased')
  end

  scenario 'User cannot find occupation through search' do
    visit(explore_occupations_path)
    fill_in('name', with: 'Embalmer')
    find('.search-button').click

    expect(page).to have_text('0 results')
  end

  scenario 'User continues journey to finding a training course' do
    visit(job_profile_path(job_profile.slug))
    click_on('Find a training course')

    expect(page).to have_text('Find and apply to a training course near you')
  end
end
