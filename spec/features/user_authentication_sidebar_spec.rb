require 'rails_helper'

RSpec.feature 'User authentication in sidebar' do
  let!(:job_profile) do
    create(
      :job_profile,
      :with_skill,
      :with_html_content,
      name: 'Hitman',
    )
  end

  let(:save_your_progress_paths) {
    [
      skills_path,
      check_your_skills_path,
      skills_matcher_index_path,
      job_profile_path(job_profile.slug),
      training_hub_path,
      english_course_overview_path,
      maths_course_overview_path,
      courses_path('english'),
      next_steps_path
    ]
  }

  before do
    enable_feature!(:user_authentication, :skills_builder_v2)
    client = instance_spy(Notifications::Client)
    allow(Notifications::Client).to receive(:new).and_return(client)
  end

  def unlock_pages
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    find('.govuk-button').click

    click_on('Find out what you can do with these skills')
  end

  def register_user
    unlock_pages
    visit(save_your_results_path)
    fill_in('email', with: 'test@test.test')

    click_on('Save your results')
  end

  scenario 'user sees save your results in sidebar' do
    unlock_pages

    save_your_progress_paths.each do |path|
      visit(path)

      expect(page).to have_text('Save your results')
    end
  end

  scenario 'user does not see save your results in sidebar if user registered' do
    register_user

    save_your_progress_paths.each do |path|
      visit(path)

      expect(page).not_to have_text('Save your results')
    end
  end

  scenario 'user does not see save your results with no previously selected skills' do
    visit(check_your_skills_path)

    expect(page).not_to have_text('Save your results')
  end

  context 'when user authentication feature is off' do
    before do
      disable_feature! :user_authentication
    end

    scenario 'user does not see save your results in sidebar' do
      unlock_pages

      save_your_progress_paths.each do |path|
        visit(path)
        expect(page).not_to have_text('Save your results')
      end
    end
  end
end
