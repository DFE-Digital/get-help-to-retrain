require 'rails_helper'

RSpec.feature 'Build your skills V2', type: :feature do
  background do
    disable_feature! :skills_builder
    enable_feature! :skills_builder_v2
  end

  let!(:job_profile) do
    create(
      :job_profile,
      :with_html_content,
      name: 'Hitman',
      skills: [
        create(:skill, name: 'Chameleon-like blend in tactics'),
        create(:skill, name: 'License to kill'),
        create(:skill, name: 'Baldness')
      ]
    )
  end

  def build_max_job_profiles
    5.times do |i|
      job_profile = create(
        :job_profile,
        :with_html_content,
        :with_skill,
        name: "Hitman#{i}"
      )

      visit(job_profile_skills_path(job_profile_id: job_profile.slug))
      find('.govuk-button').click
    end
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

  scenario 'User selects the skills for the first job profile and can see the skills' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    find('.govuk-button').click

    expect(page).to have_selector('tbody tr', count: 3)
  end

  scenario 'User selects the skills for the first job profile and can see the current job title' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    find('.govuk-button').click

    expect(page).to have_text(/Hitman/)
  end

  scenario 'User selects the skills for the first job profile and can edit the skills' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    find('.govuk-button').click
    click_on('edit these skills')
    uncheck('Baldness', allow_label_click: true)
    find('.govuk-button').click

    expect(page).not_to have_text('Baldness')
  end

  scenario 'User unticks all skills for a second profile then that profile should not be on Your Skills page' do
    hitman = create(
      :job_profile,
      :with_html_content,
      :with_skill,
      name: 'Hitman'
    )

    assassin = create(
      :job_profile,
      :with_html_content,
      name: 'Assasin',
      skills: [
        create(:skill, name: 'Classic')
      ]
    )
    visit(job_profile_skills_path(job_profile_id: hitman.slug))
    find('.govuk-button').click
    visit(job_profile_skills_path(job_profile_id: assassin.slug))
    find('.govuk-button').click
    visit(job_profile_skills_path(job_profile_id: assassin.slug))
    uncheck('Classic', allow_label_click: true)
    find('.govuk-button').click
    visit(skills_path)

    expect(page).not_to have_text('Assassin')
  end

  scenario 'User chooses which skills to select and continues to see those selected skills' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('Baldness', allow_label_click: true)
    find('.govuk-button').click

    expect(page).to have_selector('tbody tr', count: 2)
  end

  scenario 'User can search for other job profiles' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    find('.govuk-button').click
    click_on('Add more skills from another role')

    expect(page).to have_text('Add more skills')
  end

  scenario 'User can not add a job that is part of Your skills page already' do
    create(
      :job_profile,
      :with_html_content,
      name: 'Classic-hitman',
      skills: [
        create(:skill, name: 'Classic'),
        create(:skill, name: 'James Bond like'),
        create(:skill, name: 'Martini lover')
      ]
    )

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    find('.govuk-button').click
    click_on('Add more skills from another role')
    fill_in('search', with: 'Hitman')
    find('.search-button').click

    expect(page).not_to have_text('/Hitman/')
  end

  scenario 'User can add more job profiles as part of their skill set' do
    create(
      :job_profile,
      :with_html_content,
      name: 'Classic-hitman',
      skills: [
        create(:skill, name: 'Classic'),
        create(:skill, name: 'James Bond like'),
        create(:skill, name: 'Martini lover')
      ]
    )

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    find('.govuk-button').click
    click_on('Add more skills from another role')
    fill_in('search', with: 'Hitman')
    find('.search-button').click
    click_on('Classic-hitman')
    find('.govuk-button').click

    ['Classic-hitman', 'Classic', 'James Bond like', 'Martini lover', 'Hitman', 'Chameleon-like blend in tactics', 'License to kill', 'Baldness'].each do |title|
      expect(page).to have_text(title)
    end
  end

  scenario 'User can not add more than 5 profiles' do
    build_max_job_profiles

    job_profile = create(
      :job_profile,
      :with_html_content,
      name: 'Hitman6',
      skills: [
        create(:skill)
      ]
    )

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    expect(page).not_to have_link('Add more skills from another role')
  end

  scenario 'User can not search for job profiles anymore when one has 5 profiles persisted on the session' do
    build_max_job_profiles

    click_on('Check your existing skills')

    expect(page).to have_current_path(skills_path)
  end

  scenario 'User can not select skills for a 6th job and gets redirected to Your Skills page with 5 profiles' do
    build_max_job_profiles

    job_profile = create(
      :job_profile,
      :with_html_content,
      name: 'Hitman5',
      skills: [
        create(:skill)
      ]
    )

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))

    %w[Hitman0 Hitman1 Hitman2 Hitman3 Hitman4].each do |title|
      expect(page).to have_text(title)
    end
  end

  scenario 'User can still get to edit the skills page when one has already 5 job profiles' do
    build_max_job_profiles

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))

    first(:link, 'edit these skills').click

    expect(page).to have_selector('input[checked="checked"]', count: 1)
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
    find('.govuk-button').click
    click_on('Search results')
    click_on('Assassin')

    expect(page).to have_selector('input[checked="checked"]', count: 3)
  end

  scenario 'skill builder requires at least one skill selected' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('Chameleon-like blend in tactics', allow_label_click: true)
    uncheck('License to kill', allow_label_click: true)
    uncheck('Baldness', allow_label_click: true)

    find('.govuk-button').click

    expect(page).to have_text(/Select at least one skill/)
  end

  scenario 'User navigates to the last added job profile skills page from breadcrumbs' do
    build_max_job_profiles

    visit(skills_path(job_profile_id: 'hitman4'))

    click_on('Job skills')

    expect(page).to have_text('Hitman4')
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
