require 'rails_helper'

RSpec.feature 'Action plan spec' do
  let(:skill1) { create(:skill, name: 'Good communication') }
  let(:skill2) { create(:skill, name: 'Charisma') }
  let(:skill3) { create(:skill, name: 'Good persuasion') }

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

    expect(page).to have_link('Edit your skills', href: skills_path)
  end

  scenario 'Page links to training questions' do
    user_targets_a_job

    expect(page).to have_link('Edit your training choices', href: edit_training_questions_path)
  end

  scenario 'Page links to English courses if training question answered for english' do
    user_targets_a_job
    click_on('Edit your training choices')
    check('I need to improve my English skills', allow_label_click: true)
    click_on('Continue')

    expect(page).to have_link('Find an English course', href: courses_path(:english))
  end

  scenario 'Page links to maths courses if training question answered for maths' do
    user_targets_a_job
    click_on('Edit your training choices')
    check('I need to improve my maths skills', allow_label_click: true)
    click_on('Continue')

    expect(page).to have_link('Find a maths course', href: courses_path(:maths))
  end

  scenario 'Page links to IT training provider if IT training question answered' do
    user_targets_a_job
    click_on('Edit your training choices')
    check('I need to improve my computer skills', allow_label_click: true)
    click_on('Continue')

    expect(page).to have_link('Go to learning provider website', href: 'https://www.learnmyway.com/subjects')
  end

  scenario 'If user edits training options, options are persisted if user revisits edit page' do
    user_targets_a_job
    click_on('Edit your training choices')
    check('I need to improve my maths skills', allow_label_click: true)
    check('I need to improve my computer skills', allow_label_click: true)
    click_on('Continue')
    click_on('Edit your training choices')

    expect(page).to have_selector('input[checked="checked"]', count: 2)
  end

  scenario 'If user edits training options, they get tracked in GA' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    user_targets_a_job
    click_on('Edit your training choices')
    check('I need to improve my maths skills', allow_label_click: true)
    check('I need to improve my English skills', allow_label_click: true)
    click_on('Continue')

    expect(tracking_service).to have_received(:track_events).with(
      props:
      [
        {
          key: :training_ticked,
          label: 'Check your maths and English skills',
          value: 'english_skills'
        },
        {
          key: :training_ticked,
          label: 'Check your maths and English skills',
          value: 'math_skills'
        }
      ]
    )
  end

  scenario 'If user edits IT training options, they get tracked in GA' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    user_targets_a_job
    click_on('Edit your training choices')
    check('I need to improve my computer skills', allow_label_click: true)
    click_on('Continue')

    expect(tracking_service).to have_received(:track_events).with(
      props:
      [
        {
          key: :it_training_ticked,
          label: 'Computer skills training',
          value: 'computer_skills'
        }
      ]
    )
  end

  scenario 'If user selects no training options, we still track those options in GA' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    user_targets_a_job
    click_on('Edit your training choices')
    uncheck('I need to improve my English skills', allow_label_click: true)
    uncheck('I need to improve my maths skills', allow_label_click: true)
    click_on('Continue')

    expect(tracking_service).to have_received(:track_events).with(
      props:
      [
        {
          key: :training_unticked,
          label: 'Check your maths and English skills',
          value: 'english_skills'
        },
        {
          key: :training_unticked,
          label: 'Check your maths and English skills',
          value: 'math_skills'
        }
      ]
    ).twice
  end

  scenario 'If user selects no IT training options, we still track those options in GA' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    user_targets_a_job
    click_on('Edit your training choices')
    uncheck('I need to improve my computer skills', allow_label_click: true)
    click_on('Continue')

    expect(tracking_service).to have_received(:track_events).with(
      props:
      [
        {
          key: :it_training_unticked,
          label: 'Computer skills training',
          value: 'computer_skills'
        }
      ]
    ).twice
  end

  scenario 'Page shows different content if no training nor IT training questions answered' do
    user_targets_a_job

    expect(page).to have_text('You chose not to get help')
  end

  scenario 'Page links to edit job hunting questions page' do
    user_targets_a_job

    expect(page).to have_link('Edit your advice choices', href: edit_job_hunting_questions_path)
  end

  scenario 'User can navigate back to action plan after trying to edit the advice options' do
    user_targets_a_job

    click_on('Edit your advice choices')
    click_on('Action plan')

    expect(page).to have_current_path(action_plan_path)
  end

  scenario 'If user edits job hunting options, options are persisted if user revisits edit page' do
    user_targets_a_job
    click_on('Edit your advice choices')
    check('I want advice on creating or updating a CV', allow_label_click: true)
    check('I want advice on writing a cover letter', allow_label_click: true)
    click_on('Continue')
    click_on('Edit your advice choices')

    expect(page).to have_selector('input[checked="checked"]', count: 2)
  end

  scenario 'Page links to cv help if job hunting question answered for cv' do
    user_targets_a_job
    click_on('Edit your advice choices')
    check('I want advice on creating or updating a CV', allow_label_click: true)
    click_on('Continue')
    click_on('Get CV advice')

    expect(page).to have_current_path(cv_advice_path)
  end

  scenario 'Page links to cover letter help if job hunting question answered for cover letter' do
    user_targets_a_job
    click_on('Edit your advice choices')
    check('I want advice on writing a cover letter', allow_label_click: true)
    click_on('Continue')
    click_on('Get cover letter advice')

    expect(page).to have_current_path(cover_letter_advice_path)
  end

  scenario 'Page links to interview prep help if job hunting question answered for interview prep' do
    user_targets_a_job
    click_on('Edit your advice choices')
    check('I want advice on preparing for interviews', allow_label_click: true)
    click_on('Continue')
    click_on('Get interview advice')

    expect(page).to have_current_path(interview_advice_path)
  end

  scenario 'Page shows different content if no job hunting questions answered' do
    user_targets_a_job

    expect(page).to have_text('You did not choose to get advice')
  end

  scenario 'If user edits job hunting options, they get tracked in GA' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    user_targets_a_job
    click_on('Edit your advice choices')
    check('I want advice on preparing for interviews', allow_label_click: true)
    click_on('Continue')

    expect(tracking_service).to have_received(:track_events).with(
      props:
      [
        {
          key: :job_hunting_ticked,
          label: 'Get help with your job hunting skills',
          value: 'interviews'
        },
        {
          key: :job_hunting_unticked,
          label: 'Get help with your job hunting skills',
          value: 'cv'
        },
        {
          key: :job_hunting_unticked,
          label: 'Get help with your job hunting skills',
          value: 'cover_letter'
        }
      ]
    )
  end

  scenario 'Page links to nearby jobs' do
    user_targets_a_job

    expect(page).to have_link('Show jobs near you', href: jobs_near_me_path)
  end

  scenario 'Page links to offers near me' do
    user_targets_a_job
    click_on('See local offers')

    expect(page).to have_current_path(offers_near_me_path)
  end

  scenario 'Page links to apprenticeships page' do
    user_targets_a_job

    expect(page).to have_link('Find an apprenticeship', href: 'https://www.findapprenticeship.service.gov.uk/apprenticeshipsearch?searchMode=Category')
  end

  scenario 'Page links to funding info page' do
    user_targets_a_job

    click_on('Find out about funding')

    expect(page).to have_current_path(funding_information_path)
  end

  scenario 'Users do not see their selected skills if they have none on the session' do
    user_targets_a_job

    expect(page).not_to have_text('View your selected skills')
  end

  scenario 'Users see their selected deduped skills if they are present on the session' do
    current_job_profile = build_custom_job_profile(
      title: 'Head of sales',
      skills: [skill1, skill2, skill3]
    )

    previous_job_profile = build_custom_job_profile(
      title: 'Salesman',
      skills: [skill1, skill2]
    )

    build_custom_job_profile(
      title: 'Dream job',
      skills: [skill1, skill2, skill3]
    )

    select_skills_for(job_profile: current_job_profile)
    select_skills_for(job_profile: previous_job_profile)
    click_on('Find out what you can do with these skills')
    click_on('Dream job')
    click_on('Select this type of work')
    skip_training_questions

    ['View your selected skills', 'Good communication', 'Charisma', 'Good persuasion'].each do |skill|
      expect(page).to have_text(skill).once
    end
  end

  private

  def user_targets_a_job
    create(:job_profile, :with_html_content, name: 'Fluffer', slug: 'fluffer').tap do |job_profile|
      visit(job_profile_path(job_profile.slug))
      click_on('Select this type of work')
      click_on('Continue')
      click_on('Continue')
      click_on('Continue')
    end
  end

  def capture_user_location
    visit(your_information_path)
    fill_in('user_personal_data[first_name]', with: 'John')
    fill_in('user_personal_data[last_name]', with: 'Mayer')
    fill_in('user_personal_data[postcode]', with: 'NW11 8QE')
    fill_in('user_personal_data[birth_day]', with: '1')
    fill_in('user_personal_data[birth_month]', with: '1')
    fill_in('user_personal_data[birth_year]', with: DateTime.now.year - 20)
    choose('user_personal_data[gender]', option: 'male')

    click_on('Continue')
  end

  def build_custom_job_profile(title:, skills: [])
    create(
      :job_profile,
      :with_html_content,
      name: title,
      skills: skills
    )
  end

  def select_skills_for(job_profile:)
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')
  end

  def skip_training_questions
    3.times { click_on('Continue') }
  end
end
