require 'rails_helper'

RSpec.feature 'Skills matcher', type: :feature do
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

  background do
    enable_feature! :skills_builder
    create(:job_profile, :with_html_content, name: 'Assasin', skills: [skill1, skill2])
  end

  scenario 'User explores their occupations through skills matcher results' do
    visit(job_profile_skills_path(job_profile_id: job_profile1.slug))
    find('.govuk-button').click
    click_on('Find out what you can do with these skills')
    visit(skills_matcher_index_path)
    click_on('Assasin')

    expect(page).to have_text('Chameleon-like blend in tactics')
  end

  scenario 'returns other profiles than one selected for skills' do
    visit(job_profile_skills_path(job_profile_id: job_profile1.slug))
    find('.govuk-button').click
    click_on('Find out what you can do with these skills')
    visit(skills_matcher_index_path)

    expect(page).not_to have_text('Hitman')
  end

  scenario 'does not return profiles if skills not present' do
    create(:job_profile, name: 'Hacker', skills: [skill2])
    visit(job_profile_skills_path(job_profile_id: job_profile1.slug))
    uncheck('License to kill', allow_label_click: true)
    find('.govuk-button').click
    click_on('Find out what you can do with these skills')
    visit(skills_matcher_index_path)

    expect(page).not_to have_text('Hacker')
  end

  scenario 'arranges profiles according to descending matching score' do
    create(:job_profile, name: 'Hacker', skills: [skill1, skill2, skill3])
    visit(job_profile_skills_path(job_profile_id: job_profile1.slug))
    find('.govuk-button').click
    click_on('Find out what you can do with these skills')
    visit(skills_matcher_index_path)

    expect(page.all('ul.govuk-list li a').collect(&:text)).to eq(%w[Hacker Assasin])
  end

  scenario 'arranges profiles alphabetically if they share a score' do
    create(:job_profile, name: 'Hacker', skills: [skill2])
    create(:job_profile, name: 'Admin', skills: [skill1, skill2])
    visit(job_profile_skills_path(job_profile_id: job_profile1.slug))
    find('.govuk-button').click
    click_on('Find out what you can do with these skills')
    visit(skills_matcher_index_path)

    expect(page.all('ul.govuk-list li a').collect(&:text)).to eq(%w[Admin Assasin Hacker])
  end

  scenario 'paginates results of search' do
    create_list(:job_profile, 12, name: 'Hacker', skills: [skill1])
    visit(job_profile_skills_path(job_profile_id: job_profile1.slug))
    find('.govuk-button').click
    click_on('Find out what you can do with these skills')
    visit(skills_matcher_index_path)

    expect(page).to have_selector('ul.govuk-list li', count: 10)
  end

  scenario 'allows user to paginate through results' do
    create_list(:job_profile, 11, name: 'Hacker', skills: [skill1])
    visit(job_profile_skills_path(job_profile_id: job_profile1.slug))
    find('.govuk-button').click
    click_on('Find out what you can do with these skills')
    click_on('Next')

    expect(page).to have_selector('ul.govuk-list li', count: 2)
  end
end
