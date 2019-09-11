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

  before do
    enable_feature!(:user_authentication, :skills_builder_v2)
  end

  scenario 'user sees save your results page when navigating from sidebar' do
    visit(job_profile_skills_path(job_profile_id: job_profile1.slug))
    find('.govuk-button').click
    click_on('Save my results')
    expect(page).to have_current_path(save_your_results_path)
  end

  scenario 'User gets relevant messaging if no email is entered' do
    visit(save_your_results_path)
    click_on('Save your results')

    expect(page).to have_text(/Enter an email address/)
  end

  scenario 'User gets relevant messaging if invalid email is entered' do
    visit(save_your_results_path)
    fill_in('email', with: 'wrong email')
    click_on('Save your results')

    expect(page).to have_text(/Enter a valid email address/)
  end
end
