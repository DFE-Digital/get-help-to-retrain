require 'rails_helper'

RSpec.feature 'Tasks List', type: :feature do
  scenario 'User navigates to task list page' do
    disable_feature! :location_eligibility
    visit(root_path)
    click_on('Start now')

    expect(page).to have_text('Here\'s what you need to do to retrain for another job.')
  end

  scenario 'User checks their existing skills' do
    visit(task_list_path)
    click_on('Check your existing skills')

    expect(page).to have_text('Check your existing skills')
  end

  scenario 'User explores their occupation' do
    disable_feature! :skills_builder
    visit(task_list_path)
    click_on('Search for the types of jobs you could retrain to do')

    expect(page).to have_text('Explore occupations')
  end

  scenario 'User navigates to skills matcher results page' do
    enable_feature! :skills_builder
    skill = create(:skill)
    job_profile = create(:job_profile, name: 'Assassin', skills: [skill])
    create(:job_profile, name: 'Hitman', skills: [skill])

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    find('.govuk-button').click
    visit(task_list_path)
    click_on('Search for the types of jobs you could retrain to do')

    expect(page).to have_text('Types of jobs that match your skills')
  end

  scenario 'User finds a training course' do
    disable_feature! :course_directory

    visit(task_list_path)
    click_on('Find a training course')

    expect(page).to have_text('Find and apply to a training course near you')
  end

  scenario 'User finds ouy next steps' do
    visit(task_list_path)
    click_on('Get more support to help you on your new career path')

    expect(page).to have_text('Get advice and help in your search for a new role.')
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

  scenario 'Smart survey link is present under Help improve this service section' do
    visit(task_list_path)

    link = find_link('Take a quick survey and tell us about your experience ')

    expect([link[:href], link[:target]]).to eq(
      [
        'https://www.smartsurvey.co.uk/s/get-help-to-retrain/',
        '_blank'
      ]
    )
  end

  scenario 'User navigates to task list page when course directory feature is enabled' do
    enable_feature! :course_directory

    visit(task_list_path)

    expect(page).to have_selector(:css, 'a[href="/training-hub"]')
  end
end
