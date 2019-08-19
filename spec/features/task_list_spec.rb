require 'rails_helper'

RSpec.feature 'Tasks List', type: :feature do
  scenario 'User navigates to task list page' do
    disable_feature! :location_eligibility
    visit(root_path)
    click_on('Start now')

    expect(page).to have_text('Here\'s what you need to do to retrain for another job.')
  end

  scenario 'With a clean new session the user will see sections 2,3,4,5 locked' do
    disable_feature! :location_eligibility
    visit(task_list_path)

    (2..5).each do |section_no|
      expect(page).to have_css("span#section-#{section_no}-blocked")
    end
  end

  scenario 'With a clean new session the user will not be able to click sections 2,3,4,5' do
    disable_feature! :location_eligibility
    visit(task_list_path)

    ['See types of jobs that match your skills', 'Find a training course', 'Find other ways to change jobs', 'Take a quick survey'].each do |link|
      expect(page).to have_no_link(link)
    end
  end

  scenario 'User checks their existing skills' do
    visit(task_list_path)
    click_on('Check your existing skills')

    expect(page).to have_text('Check your existing skills')
  end

  scenario 'User navigates to skills matcher results page' do
    enable_feature! :skills_builder
    skill = create(:skill)
    job_profile = create(:job_profile, name: 'Assassin', skills: [skill])
    create(:job_profile, name: 'Hitman', skills: [skill])

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    find('.govuk-button').click
    click_on('Find out what you can do with these skills')

    visit(task_list_path)

    click_on('See types of jobs that match your skills')

    expect(page).to have_text('Types of jobs that match your skills')
  end

  scenario 'User unlocks the training course section by clicking Other ways to change jobs from job profile page' do
    enable_feature! :course_directory, :skills_builder

    job_profile = create(
      :job_profile,
      :with_html_content,
      name: 'Assassin',
      skills: [
        create(:skill, name: 'Chameleon-like blend in tactics')
      ]
    )

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    find('.govuk-button').click
    click_on('Find out what you can do with these skills')
    visit(job_profile_path(job_profile.slug))
    click_on('Other ways to change jobs')

    visit(task_list_path)
    click_on('Find a training course')

    expect(page).to have_text('Find training that boosts your job options')
  end

  scenario 'User unlocks the training course section by clicking Find a training course from job profile page' do
    enable_feature! :course_directory, :skills_builder

    job_profile = create(
      :job_profile,
      :with_html_content,
      name: 'Assassin',
      skills: [
        create(:skill, name: 'Chameleon-like blend in tactics')
      ]
    )

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    find('.govuk-button').click
    click_on('Find out what you can do with these skills')
    visit("job-profiles/#{job_profile.slug}")
    click_on('Find a training course')

    visit(task_list_path)
    click_on('Find a training course')

    expect(page).to have_text('Find training that boosts your job options')
  end

  scenario 'User unlocks next steps section by clicking Find a training course from job profile page' do
    enable_feature! :course_directory, :skills_builder

    job_profile = create(
      :job_profile,
      :with_html_content,
      name: 'Assassin',
      skills: [
        create(:skill, name: 'Chameleon-like blend in tactics')
      ]
    )

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    find('.govuk-button').click
    click_on('Find out what you can do with these skills')
    visit("job-profiles/#{job_profile.slug}")
    click_on('Find a training course')

    visit(task_list_path)
    click_on('Find other ways to change jobs')

    expect(page).to have_text('Further help to find work')
  end

  scenario 'User unlocks next steps section by clicking Other ways to change jobs from job profile page' do
    enable_feature! :course_directory, :skills_builder

    job_profile = create(
      :job_profile,
      :with_html_content,
      name: 'Assassin',
      skills: [
        create(:skill, name: 'Chameleon-like blend in tactics')
      ]
    )

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    find('.govuk-button').click
    click_on('Find out what you can do with these skills')
    visit("job-profiles/#{job_profile.slug}")
    click_on('Other ways to change jobs')

    visit(task_list_path)
    click_on('Find other ways to change jobs')

    expect(page).to have_text('Further help to find work')
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

  scenario 'User unlocks survey section by clicking Find a training course from job profile page' do
    enable_feature! :course_directory, :skills_builder

    job_profile = create(
      :job_profile,
      :with_html_content,
      name: 'Assassin',
      skills: [
        create(:skill, name: 'Chameleon-like blend in tactics')
      ]
    )

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    find('.govuk-button').click
    click_on('Find out what you can do with these skills')
    visit("job-profiles/#{job_profile.slug}")
    click_on('Find a training course')

    visit(task_list_path)

    link = find_link('Take a quick survey')

    expect([link[:href], link[:target]]).to eq(
      [
        'https://www.smartsurvey.co.uk/s/get-help-to-retrain/',
        '_blank'
      ]
    )
  end

  scenario 'User unlocks survey section by clicking Other ways to change jobs from job profile page' do
    enable_feature! :course_directory, :skills_builder

    job_profile = create(
      :job_profile,
      :with_html_content,
      name: 'Assassin',
      skills: [
        create(:skill, name: 'Chameleon-like blend in tactics')
      ]
    )

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    find('.govuk-button').click
    click_on('Find out what you can do with these skills')
    visit("job-profiles/#{job_profile.slug}")
    click_on('Other ways to change jobs')

    visit(task_list_path)

    link = find_link('Take a quick survey')

    expect([link[:href], link[:target]]).to eq(
      [
        'https://www.smartsurvey.co.uk/s/get-help-to-retrain/',
        '_blank'
      ]
    )
  end

  scenario 'User unlocks skill matcher section when clicking on Find out what you can do with these skills from /jobs-match' do
    enable_feature! :course_directory, :skills_builder

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
    find('.govuk-button').click
    click_on('Find out what you can do with these skills')

    visit(task_list_path)

    click_on('See types of jobs that match your skills')

    expect(page).to have_text('Types of jobs that match your skills')
  end

  scenario 'Unlocking skill matcher section does not unlock sections 3,4,5' do
    enable_feature! :course_directory, :skills_builder

    job_profile = create(
      :job_profile,
      :with_html_content,
      name: 'Assassin',
      skills: [
        create(:skill, name: 'Chameleon-like blend in tactics')
      ]
    )

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    find('.govuk-button').click
    click_on('Find out what you can do with these skills')

    visit(task_list_path)

    (3..5).each do |section_no|
      expect(page).to have_css("span#section-#{section_no}-blocked")
    end
  end

  scenario 'Unlocking skill matcher section does not allow clicking sections 3,4,5' do
    enable_feature! :course_directory, :skills_builder

    job_profile = create(
      :job_profile,
      :with_html_content,
      name: 'Assassin',
      skills: [
        create(:skill, name: 'Chameleon-like blend in tactics')
      ]
    )

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    find('.govuk-button').click
    click_on('Find out what you can do with these skills')

    visit(task_list_path)

    ['Find a training course', 'Find other ways to change jobs', 'Take a quick survey'].each do |link|
      expect(page).to have_no_link(link)
    end
  end
end
