require 'rails_helper'

RSpec.feature 'Action plan spec' do
  background do
    enable_feature! :action_plan
  end

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

  scenario 'Page links to English courses' do
    user_targets_a_job

    expect(page).to have_link('Find an English course', href: courses_path(:english))
  end

  scenario 'Page links to maths courses' do
    user_targets_a_job

    expect(page).to have_link('Find a maths course', href: courses_path(:maths))
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
      click_on('Target this job')
    end
  end
end
