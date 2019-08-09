require 'rails_helper'

RSpec.feature 'Build your skills', type: :feature do
  background do
    enable_feature! :skills_builder
  end

  let!(:job_profile) do
    create(
      :job_profile,
      name: 'Hitman',
      skills: [
        create(:skill, name: 'Chameleon-like blend in tactics'),
        create(:skill, name: 'License to kill'),
        create(:skill, name: 'Baldness')
      ]
    )
  end

  scenario 'User sees a list of skills when checking their Job skills' do
    visit(check_your_skills_path)
    fill_in('search', with: 'Hitman')
    find('.search-button').click
    click_on('Hitman')

    expect(page).to have_selector('div.govuk-checkboxes div.govuk-checkboxes__item', count: 3)
  end

  scenario 'User sees a list of skills all pre-checked' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))

    expect(page).to have_selector('input[checked="checked"]', count: 3)
  end

  scenario 'User continues to see all skills selected' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    find('.govuk-button').click

    expect(page).to have_selector('tbody tr', count: 3)
  end

  scenario 'User chooses which skills to select and continues to see those selected skills' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('Baldness', allow_label_click: true)
    find('.govuk-button').click

    expect(page).to have_selector('tbody tr', count: 2)
  end

  scenario 'skill builder requires at least one skill selected' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('Chameleon-like blend in tactics', allow_label_click: true)
    uncheck('License to kill', allow_label_click: true)
    uncheck('Baldness', allow_label_click: true)

    find('.govuk-button').click

    expect(page).to have_text(/Select at least one skill/)
  end

  scenario 'breadcrumbs navigate back to search results from your skills' do
    visit(check_your_skills_path)
    fill_in('search', with: 'Hitman')
    find('.search-button').click
    click_on('Hitman')
    find('.govuk-button').click
    click_on('Search results')

    expect(page).to have_text(/Hitman/)
  end

  context 'when feature disabled' do
    background do
      disable_feature! :skills_builder
    end

    scenario 'User is taken to static list of skills' do
      visit(check_your_skills_path)
      fill_in('search', with: 'Hitman')
      find('.search-button').click
      click_on('Hitman')

      expect(page).not_to have_selector('div.govuk-checkboxes div.govuk-checkboxes__item')
    end
  end
end
