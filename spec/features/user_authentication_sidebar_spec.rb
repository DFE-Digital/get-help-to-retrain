require 'rails_helper'

RSpec.feature 'User authentication in sidebar' do
  let!(:skill1) { create(:skill, name: 'Chameleon-like blend in tactics') }
  let!(:skill2) { create(:skill, name: 'License to kill') }
  let!(:skill3) { create(:skill, name: 'Baldness') }

  let!(:job_profile1) do
    create(
      :job_profile,
      :with_html_content,
      name: 'Hitman',
      skills: [
        skill1,
        skill2,
        skill3
      ]
    )
  end

  let(:save_your_progress_paths) {
    [
      skills_path,
      check_your_skills_path,
      skills_matcher_index_path,
      job_profile_path(job_profile1.slug),
      training_hub_path,
      english_course_overview_path,
      maths_course_overview_path,
      courses_path('english'),
      next_steps_path
    ]
  }

  before do
    enable_feature!(:user_authentication, :skills_builder_v2)
  end

  def unlock_pages
    visit(job_profile_skills_path(job_profile_id: job_profile1.slug))
    find('.govuk-button').click

    click_on('Find out what you can do with these skills')
  end

  scenario 'user sees save your results in sidebar' do
    unlock_pages

    save_your_progress_paths.each do |path|
      visit(path)

      expect(page).to have_text('Save your results')
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
