require 'rails_helper'

RSpec.feature 'Check your skills', type: :feature do
  let!(:job_profile) do
    create(
      :job_profile,
      name: 'Bodyguard',
      skills: [
        create(:skill, name: 'Patience and the ability to remain calm in stressful situations')
      ]
    )
  end

  scenario 'User checks their current skills' do
    visit(check_your_skills_path)
    fill_in('search', with: 'Bodyguard')
    find('.search-button').click
    click_on('Bodyguard')

    expect(page).to have_text('Patience and the ability to remain calm in stressful situations')
  end

  scenario 'User continues journey to explore their careers' do
    disable_feature! :skills_builder
    visit(job_profile_skills_path(job_profile.slug))
    click_on('Explore jobs you could do')

    expect(page).to have_text('Explore occupations')
  end

  scenario 'User cannot find occupation through search' do
    visit(check_your_skills_path)
    fill_in('search', with: 'Embalmer')
    find('.search-button').click

    expect(page).to have_text('0 results')
  end

  scenario 'paginates results of search' do
    create_list(:job_profile, 12, name: 'Hacker')
    visit(check_your_skills_path)
    fill_in('search', with: 'Hacker')
    find('.search-button').click

    expect(page).to have_selector('ul.govuk-list li', count: 10)
  end

  scenario 'allows user to paginate through results' do
    create_list(:job_profile, 12, name: 'Hacker')
    visit(check_your_skills_path)
    fill_in('search', with: 'Hacker')
    find('.search-button').click
    click_on('Next')

    expect(page).to have_selector('ul.govuk-list li', count: 2)
  end

  scenario 'search form required field available when no js running' do
    visit(check_your_skills_path)

    expect(page).to have_selector('#search[required]')
  end

  scenario 'search form required field disabled by default', :js do
    visit(check_your_skills_path)

    expect(page).not_to have_selector('#search[required]')
  end

  scenario 'cannot send search form with no input', :js do
    visit(check_your_skills_path)
    fill_in('search', with: '')
    find('.search-button').click

    expect(page).to have_current_path(check_your_skills_path)
  end

  scenario 'cannot send results search form with no input', :js do
    create(:job_profile, name: 'Hacker')
    visit(results_check_your_skills_path(search: 'Hacker'))
    fill_in('search', with: '')
    find('.search-button-results').click

    expect(page).to have_text('1 results found')
  end
end
