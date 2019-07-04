require 'rails_helper'

RSpec.feature 'Check your skills', type: :feature do
  let!(:job_profile) do
    create(
      :job_profile,
      name: 'Bodyguard',
      skills: [
        create(:skill, name: 'Patience and the ability to remain calm in stressful situations')
      ]
    )
  end

  scenario 'User checks their current skills' do
    visit(check_your_skills_path)
    fill_in('name', with: 'Bodyguard')
    find('.search-button').click
    click_on('Bodyguard')

    expect(page).to have_text('Patience and the ability to remain calm in stressful situations')
  end

  scenario 'User continues journey to explore their careers' do
    visit(job_profile_skills_path(job_profile.slug))
    click_on('Explore jobs you could do')

    expect(page).to have_text('Explore occupations')
  end

  scenario 'User cannot find occupation through search' do
    visit(check_your_skills_path)
    fill_in('name', with: 'Embalmer')
    find('.search-button').click

    expect(page).to have_text('0 results')
  end
end
