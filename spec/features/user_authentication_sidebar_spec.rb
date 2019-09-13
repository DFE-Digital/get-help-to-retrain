require 'rails_helper'

RSpec.feature 'User authentication in sidebar' do
  let!(:job_profile1) do
    create(
      :job_profile,
      :with_skill,
      :with_html_content,
      name: 'Hitman'
    )
  end

  let!(:job_profile2) do
    create(
      :job_profile,
      :with_skill,
      :with_html_content,
      name: 'Assasin'
    )
  end

  let(:save_your_progress_paths) {
    [
      skills_path,
      check_your_skills_path,
      results_check_your_skills_path,
      job_profile_skills_path(job_profile1.slug),
      skills_matcher_index_path,
      job_profile_path(job_profile1.slug),
      training_hub_path,
      english_course_overview_path,
      maths_course_overview_path,
      courses_path('english'),
      next_steps_path
    ]
  }

  let(:sign_in_paths) {
    [
      root_path,
      location_eligibility_path,
      your_information_path,
      task_list_path,
      check_your_skills_path,
      results_check_your_skills_path,
      job_profile_skills_path(job_profile1.slug)
    ]
  }

  before do
    enable_feature!(:user_authentication, :skills_builder_v2, :user_personal_data)
    client = instance_spy(Notifications::Client)
    allow(Notifications::Client).to receive(:new).and_return(client)
  end

  def unlock_tasklist_steps(job_profile: job_profile1)
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')

    click_on('Find out what you can do with these skills')
  end

  def register_user
    visit(save_your_results_path)
    fill_in('email', with: 'test@test.test')
    page.driver.header('User-Agent', 'some-agent')
    click_on('Save your results')
  end

  context 'when user saves their progress' do
    scenario 'user sees save your results in sidebar' do
      unlock_tasklist_steps

      save_your_progress_paths.each do |path|
        visit(path)

        expect(page).to have_text('Save your results')
      end
    end

    scenario 'user does not see save your results in sidebar if user registered' do
      unlock_tasklist_steps
      register_user

      save_your_progress_paths.each do |path|
        visit(path)

        expect(page).not_to have_text('Save your results')
      end
    end

    scenario 'user does not see save your results in sidebar if user existed before' do
      unlock_tasklist_steps
      register_user
      Capybara.reset_sessions!
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
        enable_feature!(:skills_builder_v2, :user_personal_data)
      end

      scenario 'user does not see save your results in sidebar' do
        unlock_tasklist_steps

        save_your_progress_paths.each do |path|
          visit(path)
          expect(page).not_to have_text('Save your results')
        end
      end
    end
  end

  context 'when user signs in' do
    scenario 'user sees return to saved results in sidebar' do
      sign_in_paths.each do |path|
        visit(path)

        expect(page).to have_text('Return to saved results')
      end
    end

    scenario 'user sees return to saved results in sidebar if user registered' do
      register_user

      sign_in_paths.each do |path|
        visit(path)

        expect(page).to have_text('Return to saved results')
      end
    end

    scenario 'user does not see return to save results when having atleast one job profile skill' do
      unlock_tasklist_steps(job_profile: job_profile1)
      unlock_tasklist_steps(job_profile: job_profile2)
      sign_in_paths = [
        check_your_skills_path,
        results_check_your_skills_path,
        job_profile_skills_path(job_profile1.slug)
      ]

      sign_in_paths.each do |path|
        visit(path)

        expect(page).not_to have_text('Return to saved results')
      end
    end

    scenario 'user does not see return to saved results in sidebar if user sign in through registration' do
      register_user
      click_on('send it again')
      Capybara.reset_sessions!
      visit(token_sign_in_path(token: Passwordless::Session.last.token))

      sign_in_paths.each do |path|
        visit(path)

        expect(page).not_to have_text('Return to saved results')
      end
    end

    xscenario 'user does not see return to saved results in sidebar if user signs in through sign in' do
    end

    context 'when user authentication feature is off' do
      before do
        disable_feature! :user_authentication
        enable_feature!(:skills_builder_v2, :user_personal_data)
      end

      scenario 'user does not see return to saved results in sidebar' do
        unlock_tasklist_steps

        sign_in_paths.each do |path|
          visit(path)

          expect(page).not_to have_text('Return to saved results')
        end
      end
    end
  end
end
