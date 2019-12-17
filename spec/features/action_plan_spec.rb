require 'rails_helper'

RSpec.feature 'Action plan spec' do
  scenario 'Redirects back to task list page without a targetted job profile' do
    visit(action_plan_path)

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'Page shows and links back to the targetted job profile' do
    job_profile = user_targets_a_job

    expect(page).to have_link(job_profile.name, href: job_profile_path(job_profile.slug))
  end

  scenario 'Page links back to skills matcher' do
    user_targets_a_job

    expect(page).to have_link('Change target type of work', href: skills_matcher_index_path)
  end

  scenario 'Page links back to skills summary' do
    user_targets_a_job

    expect(page).to have_link('View / edit your skills', href: skills_path)
  end

  scenario 'Page links to training questions' do
    user_targets_a_job

    expect(page).to have_link('Edit your maths and English training choices', href: training_questions_path)
  end

  scenario 'Page links to IT training questions' do
    user_targets_a_job

    expect(page).to have_link('Edit your IT training choices', href: it_training_questions_path)
  end

  scenario 'Page links to English courses if training question answered for english' do
    user_targets_a_job
    click_on('Edit your maths and English training choices')
    check('I need to improve my English skills', allow_label_click: true)
    click_on('Continue')

    expect(page).to have_link('Find an English course', href: courses_path(:english))
  end

  scenario 'Page links to maths courses if training question answered for maths' do
    user_targets_a_job
    click_on('Edit your maths and English training choices')
    check('I need to improve my maths skills', allow_label_click: true)
    click_on('Continue')

    expect(page).to have_link('Find a maths course', href: courses_path(:maths))
  end

  scenario 'Page links to IT training provider if IT training question answered' do
    user_targets_a_job
    click_on('Edit your IT training choices')
    check('I need to improve my computer skills', allow_label_click: true)
    click_on('Continue')

    expect(page).to have_link('Go to learning provider website', href: 'https://www.learnmyway.com/subjects')
  end

  scenario 'Page shows different content if no training nor IT training questions answered' do
    user_targets_a_job

    expect(page).to have_text('Improve your chances of getting a job')
  end

  scenario 'Page links to job hunting questions' do
    user_targets_a_job

    expect(page).to have_link('Edit your advice choices', href: job_hunting_questions_path)
  end

  scenario 'Page links to cv help if job hunting question answered for cv' do
    user_targets_a_job
    click_on('Edit your advice choices')
    check('I want advice on creating or updating a CV', allow_label_click: true)
    click_on('Continue')

    expect(page).to have_link('Get CV advice')
  end

  scenario 'Page links to cover letter help if job hunting question answered for cover letter' do
    user_targets_a_job
    click_on('Edit your advice choices')
    check('I want advice on writing a cover letter', allow_label_click: true)
    click_on('Continue')

    expect(page).to have_link('Get cover letter advice')
  end

  scenario 'Page links to interview prep help if job hunting question answered for interview prep' do
    user_targets_a_job
    click_on('Edit your advice choices')
    check('I want advice on preparing for interviews', allow_label_click: true)
    click_on('Continue')

    expect(page).to have_link('Get interview advice')
  end

  scenario 'Page shows different content if no job hunting questions answered' do
    user_targets_a_job

    expect(page).to have_text('You did not choose to get advice')
  end

  scenario 'Page links to nearby jobs' do
    user_targets_a_job

    expect(page).to have_link('Show jobs near me', href: jobs_near_me_path)
  end

  scenario 'Page links to offers near me' do
    user_targets_a_job
    click_on('Show me local offers')

    expect(page).to have_current_path(offers_near_me_path)
  end

  private

  def user_targets_a_job
    create(:job_profile, :with_html_content, name: 'Fluffer', slug: 'fluffer').tap do |job_profile|
      visit(job_profile_path(job_profile.slug))
      click_on('Target this type of work')
      click_on('Continue')
      click_on('Continue')
      click_on('Continue')
    end
  end
end
