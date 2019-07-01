require 'rails_helper'

RSpec.describe 'Explore Occupations', type: :feature do
  let!(:job_profile) do
    create(
      :job_profile,
      name: 'Zombie Killer',
      content: file_fixture('zombie_killer_content.html').read,
      salary_min: 17_000,
      salary_max: 28_000,
      categories: [create(:category, name: 'Apocalyptic services')]
    )
  end

  it 'User explores their career through categories' do
    visit(task_list_path)
    click_on('Search for the types of jobs you could retrain to do')
    click_on('Apocalyptic services')
    click_on('Zombie Killer')

    expect(page).to have_text('the ability to work well with the deceased')
  end

  it 'User explores their occupations through search' do
    visit(explore_occupations_path)
    fill_in('name', with: 'Zombie Killer')
    find('.search-button').click
    click_on('Zombie Killer')

    expect(page).to have_text('the ability to work well with the deceased')
  end

  it 'User cannot find occupation through search' do
    visit(explore_occupations_path)
    fill_in('name', with: 'Embalmer')
    find('.search-button').click

    expect(page).to have_text('0 results found')
  end

  it 'User continues journey to finding a training course' do
    visit(job_profile_path(job_profile.slug))
    click_on('Find a training course')

    expect(page).to have_text('Find and apply to a training course near you')
  end
end
