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
    fill_in('search', with: 'Zombie Killer')
    find('.search-button').click
    click_on('Zombie Killer')

    expect(page).to have_text('the ability to work well with the deceased')
  end

  scenario 'User cannot find occupation through search' do
    visit(explore_occupations_path)
    fill_in('search', with: 'Embalmer')
    find('.search-button').click

    expect(page).to have_text('0 results')
  end

  scenario 'User continues journey to finding a training course' do
    visit(job_profile_path(job_profile.slug))
    click_on('Find a training course')

    expect(page).to have_text('Find and apply to a training course near you')
  end

  scenario 'paginates results of search' do
    create_list(:job_profile, 12, name: 'Hacker')
    visit(explore_occupations_path)
    fill_in('search', with: 'Hacker')
    find('.search-button').click

    expect(page).to have_selector('ul.govuk-list li', count: 10)
  end

  scenario 'allows user to paginate through results' do
    create_list(:job_profile, 12, name: 'Hacker')
    visit(explore_occupations_path)
    fill_in('search', with: 'Hacker')
    find('.search-button').click
    click_on('Next')

    expect(page).to have_selector('ul.govuk-list li', count: 2)
  end

  scenario 'search form required field available when no js running' do
    visit(explore_occupations_path)

    expect(page).to have_selector('#search[required]')
  end

  scenario 'search form required field disabled by default', js: true do
    visit(explore_occupations_path)

    expect(page).not_to have_selector('#search[required]')
  end

  scenario 'cannot send search form with no input', js: true do
    visit(explore_occupations_path)
    fill_in('search', with: '')
    find('.search-button').click

    expect(page).to have_current_path(explore_occupations_path)
  end

  scenario 'cannot send results search form with no input', js: true do
    create(:job_profile, name: 'Hacker')
    visit(results_explore_occupations_path(search: 'Hacker'))
    fill_in('search', with: '')
    find('.search-button-results').click

    expect(page).to have_text('1 results found')
  end
end
