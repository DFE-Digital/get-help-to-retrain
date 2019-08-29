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

  scenario 'User cannot find occupation through search' do
    visit(check_your_skills_path)
    fill_in('search', with: 'Embalmer')
    find('.search-button').click

    expect(page).to have_text('No results found')
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

  scenario 'User gets relevant messaging if no search is entered' do
    visit(check_your_skills_path)
    find('.search-button').click

    expect(page).to have_text(/Enter a job title/)
  end

  scenario 'User gets relevant messaging if no search in results is entered' do
    create(:job_profile, name: 'Hacker')
    visit(results_check_your_skills_path(search: 'Hacker'))
    fill_in('search', with: '')
    find('.search-button').click

    expect(page).to have_text(/Enter a job title/)
  end
end
