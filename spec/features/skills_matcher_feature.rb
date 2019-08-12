require 'rails_helper'

RSpec.feature 'Skills matcher', type: :feature do
  let!(:job_profile) do
    create(
      :job_profile,
      :with_html_content,
      name: 'Zombie Killer',
      categories: [
        create(:category, name: 'Apocalyptic services')
      ],
      skills: [
        create(:skill, name: 'the ability to work well with the deceased')
      ]
    )
  end

  background do
    enable_feature! :skills_builder
  end

  scenario 'User explores their occupations through skills matcher results' do
    visit(skills_matcher_index_path)
    click_on('Zombie Killer')

    expect(page).to have_text('the ability to work well with the deceased')
  end

  scenario 'User continues journey to finding a training course' do
    visit(job_profile_path(job_profile.slug))
    click_on('Find a training course')

    expect(page).to have_text('Find and apply to a training course near you')
  end

  scenario 'paginates results of search' do
    create_list(:job_profile, 12, name: 'Hacker')
    visit(skills_matcher_index_path)

    expect(page).to have_selector('ul.govuk-list li', count: 10)
  end

  scenario 'allows user to paginate through results' do
    create_list(:job_profile, 11, name: 'Hacker')
    visit(skills_matcher_index_path)
    click_on('Next')

    expect(page).to have_selector('ul.govuk-list li', count: 2)
  end
end
