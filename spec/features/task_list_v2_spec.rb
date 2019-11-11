# TODO: This file will be promoted as the official one, once the action_plan feature is promoted. The old one task_list_spec.rb will be removed, and this one renamed to task_list_spec.rb

require 'rails_helper'

RSpec.feature 'Tasks List V2', type: :feature do
  background do
    enable_feature! :action_plan
  end

  def ensure_target_job_on_session
    skill = create(:skill)
    job_profile = create(:job_profile, :with_html_content, name: 'CTO', skills: [skill])
    create(:job_profile, :with_html_content, name: 'CEO', skills: [skill])

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')
    click_on('Find out what you can do with these skills')
    click_on('CEO')
    click_on('Target this type of work')
  end

  scenario 'User checks their existing skills' do
    visit(task_list_path)
    click_on('Check your existing skills')

    expect(page).to have_text('Check your existing skills')
  end

  scenario 'User navigates to skills matcher results page' do
    skill = create(:skill)
    job_profile = create(:job_profile, name: 'Assassin', skills: [skill])
    create(:job_profile, name: 'Hitman', skills: [skill])

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')
    click_on('Find out what you can do with these skills')

    visit(task_list_path)

    click_on('See types of jobs that match your skills')

    expect(page).to have_text('Types of jobs that match your skills')
  end

  scenario 'Smart survey link is present on the top banner' do
    visit(task_list_path)

    link = find_link('feedback')

    expect([link[:href], link[:target]]).to eq(
      [
        'https://www.smartsurvey.co.uk/s/get-help-to-retrain/',
        '_blank'
      ]
    )
  end

  scenario 'With a clean new session the user will see sections 2,3,4 locked' do
    visit(task_list_path)

    (2..4).each do |section_no|
      expect(page).to have_css("span#section-#{section_no}-blocked")
    end
  end

  scenario 'With a clean new session Check your skills takes user to your current job page' do
    visit(task_list_path)

    click_on('Check your existing skills')

    expect(page).to have_current_path(check_your_skills_path)
  end

  scenario 'When the session already has profile skills Check your skills takes user to the skills summary page' do
    job_profile = create(
      :job_profile,
      :with_html_content,
      name: 'Assassin',
      skills: [
        create(:skill, name: 'Chameleon-like blend in tactics')
      ]
    )

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')

    visit(task_list_path)
    click_on('Check your existing skills')

    expect(page).to have_current_path(skills_path(job_profile_id: job_profile.slug))
  end

  scenario 'With a clean new session the user will not be able to click sections 2,3,4' do
    visit(task_list_path)

    ['See types of jobs that match your skills', 'Personalised action plan', 'Take a quick survey'].each do |link|
      expect(page).to have_no_link(link)
    end
  end

  scenario 'User unlocks skill matcher section when one has skills on the session' do
    skill = create(:skill)

    job_profile = create(
      :job_profile,
      :with_html_content,
      name: 'Assassin',
      skills: [skill]
    )

    create(
      :job_profile,
      skills: [skill]
    )

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')

    visit(task_list_path)

    click_on('See types of jobs that match your skills')

    expect(page).to have_text('Types of jobs that match your skills')
  end

  scenario 'User unlocks the Plan your next steps section when one has a target job on the session' do
    ensure_target_job_on_session

    visit(task_list_path)
    click_on('Personalised action plan')

    expect(page).to have_current_path(action_plan_path)
  end

  scenario 'User sets a target job on the session, but then removes all skills -> Sections 2,3,4 become locked again' do
    ensure_target_job_on_session

    visit(task_list_path)

    click_on('Check your existing skills')
    click_on('remove this role')

    visit(task_list_path)

    (2..4).each do |section_no|
      expect(page).to have_css("span#section-#{section_no}-blocked")
    end
  end

  scenario 'User unlocks survey section when one has a target job on the session' do
    ensure_target_job_on_session

    visit(task_list_path)

    link = find_link('Take a quick survey')

    expect([link[:href], link[:target]]).to eq(
      [
        'https://www.smartsurvey.co.uk/s/get-help-to-retrain/',
        '_blank'
      ]
    )
  end
end
