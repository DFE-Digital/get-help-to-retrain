require 'rails_helper'

RSpec.feature 'Build your skills', type: :feature do
  let!(:job_profile) do
    create(
      :job_profile,
      :with_html_content,
      name: 'Hitman',
      skills: [
        create(:skill, name: 'Chameleon-like blend in tactics'),
        create(:skill, name: 'License to kill'),
        create(:skill, name: 'Baldness')
      ]
    )
  end

  def build_max_job_profiles
    5.times do |i|
      job_profile = create(
        :job_profile,
        :with_html_content,
        :with_skill,
        name: "Hitman#{i}"
      )

      visit(job_profile_skills_path(job_profile_id: job_profile.slug))
      click_on('Select these skills')
    end
  end

  def unselect_all_skills_for(job_profile)
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('Chameleon-like blend in tactics', allow_label_click: true)
    uncheck('License to kill', allow_label_click: true)
    uncheck('Baldness', allow_label_click: true)
    click_on('Select these skills')
  end

  scenario 'Breadcrumbs: user only sees 1 clickable item in the navigation' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')

    expect(page).to have_css('nav.govuk-breadcrumbs a', count: 1)
  end

  scenario 'Breadcrumbs - user can click on \'Home: Get help to retrain\' nav item' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')
    click_on('Home: Get help to retrain')

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'Breadcrumbs - \'Your skills\' nav item is present' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')

    expect(page).to have_css('nav.govuk-breadcrumbs', text: 'Your skills')
  end

  scenario 'User sees a list of skills when checking their Job skills' do
    visit(check_your_skills_path)
    fill_in('search', with: 'Hitman')
    find('.search-button').click
    click_on('Hitman')

    expect(page).to have_selector('div.govuk-checkboxes div.govuk-checkboxes__item', count: 3)
  end

  scenario 'User sees a list of skills all pre-checked' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))

    expect(page).to have_selector('input[checked="checked"]', count: 3)
  end

  scenario 'User selects the skills for the first job profile and can see the skills' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')

    expect(page).to have_text('3 skills selected')
  end

  scenario 'User selects the skills for the first job profile and can see the current job title' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')

    expect(page).to have_text(/Hitman/)
  end

  scenario 'User selects the skills for the first job profile and can edit the skills' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')
    click_on('edit these skills')
    uncheck('Baldness', allow_label_click: true)
    click_on('Select these skills')

    expect(page).not_to have_text('Baldness')
  end

  scenario 'Tracks both ticked and unticked skills' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('Baldness', allow_label_click: true)

    click_on('Select these skills')

    expect(tracking_service).to have_received(:track_events).with(
      key: :skills_builder,
      props: [
        {
          label: 'Hitman - Ticked',
          value: 'Chameleon-like blend in tactics'
        },
        {
          label: 'Hitman - Ticked',
          value: 'License to kill'
        },
        {
          label: 'Hitman - Unticked',
          value: 'Baldness'
        }
      ]
    )
  end

  scenario 'If all skills are unticked, nothing gets tracked in GA' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('Baldness', allow_label_click: true)
    uncheck('Chameleon-like blend in tactics', allow_label_click: true)
    uncheck('License to kill', allow_label_click: true)

    click_on('Select these skills')

    expect(tracking_service).not_to have_received(:track_events)
  end

  scenario 'User unticks all skills for a second profile then that profile should not be on Your Skills page' do
    hitman = create(
      :job_profile,
      :with_html_content,
      :with_skill,
      name: 'Hitman'
    )

    assassin = create(
      :job_profile,
      :with_html_content,
      name: 'Assasin',
      skills: [
        create(:skill, name: 'Classic')
      ]
    )
    visit(job_profile_skills_path(job_profile_id: hitman.slug))
    click_on('Select these skills')
    visit(job_profile_skills_path(job_profile_id: assassin.slug))
    click_on('Select these skills')
    visit(job_profile_skills_path(job_profile_id: assassin.slug))
    uncheck('Classic', allow_label_click: true)
    click_on('Select these skills')
    visit(skills_path)

    expect(page).not_to have_text('Assassin')
  end

  scenario 'User chooses which skills to select and continues to see those selected skills' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('Baldness', allow_label_click: true)
    click_on('Select these skills')

    expect(page).to have_text('2 skills selected')
  end

  scenario 'User can search for other job profiles' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')
    click_on('Add more skills from another role')

    expect(page).to have_text('Add more skills')
  end

  scenario 'User can not add a job that is part of Your skills page already' do
    create(
      :job_profile,
      :with_html_content,
      name: 'Classic-hitman',
      skills: [
        create(:skill, name: 'Classic'),
        create(:skill, name: 'James Bond like'),
        create(:skill, name: 'Martini lover')
      ]
    )

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')
    click_on('Add more skills from another role')
    fill_in('search', with: 'Hitman')
    find('.search-button').click

    expect(page).not_to have_text('/Hitman/')
  end

  scenario 'User can add more job profiles as part of their skill set' do
    create(
      :job_profile,
      :with_html_content,
      name: 'Classic-hitman',
      skills: [
        create(:skill, name: 'Martini lover')
      ]
    )

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')
    click_on('Add more skills from another role')
    fill_in('search', with: 'Hitman')
    find('.search-button').click
    click_on('Classic-hitman')
    click_on('Select these skills')

    expect(page).to have_text('1 skill selected')
  end

  scenario 'User jobs ordered correctly on skills page' do
    job_profile1 = create(
      :job_profile,
      :with_html_content,
      :with_skill,
      name: 'Hitman1'
    )
    job_profile2 = create(
      :job_profile,
      :with_html_content,
      :with_skill,
      name: 'Hitman2'
    )

    visit(job_profile_skills_path(job_profile_id: job_profile2.slug))
    click_on('Select these skills')

    visit(job_profile_skills_path(job_profile_id: job_profile1.slug))
    click_on('Select these skills')

    expect(page.all('div.govuk-grid-column-two-thirds h2.govuk-heading-m').collect(&:text)).to eq(
      [
        job_profile2.name,
        job_profile1.name
      ]
    )
  end

  scenario 'User can not add more than 5 profiles' do
    build_max_job_profiles

    job_profile = create(
      :job_profile,
      :with_html_content,
      name: 'Hitman6',
      skills: [
        create(:skill)
      ]
    )

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    expect(page).not_to have_link('Add more skills from another role')
  end

  scenario 'User can not search for job profiles anymore when one has 5 profiles persisted on the session' do
    build_max_job_profiles

    visit(check_your_skills_path)

    expect(page).to have_current_path(skills_path)
  end

  scenario 'User can not select skills for a 6th job and gets redirected to Your Skills page with 5 profiles' do
    build_max_job_profiles

    job_profile = create(
      :job_profile,
      :with_html_content,
      name: 'Hitman5',
      skills: [
        create(:skill)
      ]
    )

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))

    %w[Hitman0 Hitman1 Hitman2 Hitman3 Hitman4].each do |title|
      expect(page).to have_text(title)
    end
  end

  scenario 'User can still get to edit the skills page when one has already 5 job profiles' do
    build_max_job_profiles

    visit(job_profile_skills_path(job_profile_id: job_profile.slug))

    first(:link, 'edit these skills').click

    expect(page).to have_selector('input[checked="checked"]', count: 1)
  end

  scenario 'skill builder requires at least one skill selected' do
    unselect_all_skills_for(job_profile)

    expect(page).to have_text(/Select at least one skill/)
  end

  scenario 'remains on skills page if no skills present on session for a job profile' do
    unselect_all_skills_for(job_profile)
    visit(skills_path)

    expect(page).to have_current_path(skills_path)
  end

  scenario 'remains on skills path if no job profile selected' do
    visit(skills_path)

    expect(page).to have_current_path(skills_path)
  end

  scenario 'shows no skills selected if job profile selected but no skills selected' do
    visit(skills_path(job_profile_id: job_profile.slug))

    expect(page).to have_text(/You have not selected any skills/)
  end

  scenario 'if user deselects all skills on job profile they should appear deselected' do
    unselect_all_skills_for(job_profile)

    expect(page).not_to have_selector('input[checked="checked"]')
  end

  scenario 'user deselects all skills on job profile should not be remembered' do
    unselect_all_skills_for(job_profile)
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))

    expect(page).to have_selector('input[checked="checked"]', count: 3)
  end

  scenario 'user still finds their job in search if they deselects all skills on job profile' do
    unselect_all_skills_for(job_profile)
    visit(check_your_skills_path)
    fill_in('search', with: 'Hitman')
    find('.search-button').click

    expect(page).to have_text('Hitman')
  end

  scenario 'user cannot remove job profile by unselecting all skills' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')
    unselect_all_skills_for(job_profile)
    visit(skills_path)

    expect(page).to have_text('Hitman')
  end

  scenario 'user cannot update job profile skills by unselecting all skills' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('Chameleon-like blend in tactics', allow_label_click: true)
    click_on('Select these skills')
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    uncheck('License to kill', allow_label_click: true)
    uncheck('Baldness', allow_label_click: true)
    click_on('Select these skills')
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))

    expect(page).to have_selector('input[checked="checked"]', count: 2)
  end

  scenario 'user does not reach cap and redirect if they unselect all skills' do
    4.times do |i|
      job_profile = create(
        :job_profile,
        :with_html_content,
        :with_skill,
        name: "Hitman#{i}"
      )

      visit(job_profile_skills_path(job_profile_id: job_profile.slug))
      click_on('Select these skills')
    end

    unselect_all_skills_for(job_profile)
    visit(check_your_skills_path)

    expect(page).to have_current_path(check_your_skills_path)
  end

  scenario 'user can remove a job profile selected' do
    assassin = create(
      :job_profile,
      :with_html_content,
      name: 'Assasin',
      skills: [
        create(:skill, name: 'Classic')
      ]
    )
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')
    visit(job_profile_skills_path(job_profile_id: assassin.slug))
    click_on('Select these skills')

    all('a', text: 'remove this role')[0].click

    expect(page).not_to have_text(job_profile.name)
  end

  scenario 'user gets a flash alert with information about the removed role' do
    assassin = create(
      :job_profile,
      :with_html_content,
      name: 'Assasin',
      skills: [
        create(:skill, name: 'Classic')
      ]
    )
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')
    visit(job_profile_skills_path(job_profile_id: assassin.slug))
    click_on('Select these skills')

    all('a', text: 'remove this role')[0].click

    expect(page).to have_text('The hitman role has been removed.')
  end

  scenario 'user sees an error page if they remove their only job selected' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')

    click_on('remove this role')

    expect(page).to have_text(/You have not selected any skills/)
  end

  scenario 'user can remove job and they can see it again in search results' do
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')

    click_on('remove this role')
    click_on('Check my skills')
    fill_in('search', with: job_profile.name)
    find('.search-button').click

    expect(page).to have_text(job_profile.name)
  end
end
