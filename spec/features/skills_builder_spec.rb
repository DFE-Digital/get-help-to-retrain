require 'rails_helper'

RSpec.feature 'Build your skills', type: :feature do
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

  background do
    disable_feature! :skills_builder_v2
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
    click_on('Select these skills')

    expect(page).to have_selector('tbody tr', count: 3)
  end

  scenario 'User chooses which skills to select and continues to see those selected skills' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('Baldness', allow_label_click: true)
    click_on('Select these skills')

    expect(page).to have_selector('tbody tr', count: 2)
  end

  scenario 'User selects skills but goes back to different job profile sees all skills selected' do
    create(
      :job_profile,
      name: 'Assassin',
      skills: [
        create(:skill, name: 'Chameleon-like blend in tactics'),
        create(:skill, name: 'Mastery of unarmed combat skill'),
        create(:skill, name: 'License to kill')
      ]
    )

    visit(check_your_skills_path)
    fill_in('search', with: 'Hitman assassin')
    find('.search-button').click
    click_on('Hitman')
    uncheck('Baldness', allow_label_click: true)
    uncheck('License to kill', allow_label_click: true)
    click_on('Select these skills')
    click_on('Search results')
    click_on('Assassin')

    expect(page).to have_selector('input[checked="checked"]', count: 3)
  end

  scenario 'skill builder requires at least one skill selected' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('Chameleon-like blend in tactics', allow_label_click: true)
    uncheck('License to kill', allow_label_click: true)
    uncheck('Baldness', allow_label_click: true)

    click_on('Select these skills')

    expect(page).to have_text(/Select at least one skill/)
  end

  scenario 'breadcrumbs navigate back to search results from your skills' do
    disable_feature! :skills_builder_v2

    visit(check_your_skills_path)
    fill_in('search', with: 'Hitman')
    find('.search-button').click
    click_on('Hitman')
    click_on('Select these skills')
    click_on('Search results')

    expect(page).to have_text(/Hitman/)
  end

  scenario 'redirected to task list path if no job profile selected' do
    visit(skills_path)

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'redirected to task list path if job profile selected but no skills selected' do
    visit(skills_path(job_profile_id: job_profile.slug))

    expect(page).to have_current_path(task_list_path)
  end
end
