require 'rails_helper'

RSpec.feature 'Questions' do
  let(:job_profile) { create(:job_profile, :with_html_content) }

  scenario 'User sees training questions when targetting a job' do
    user_targets_job

    expect(page).to have_current_path(training_questions_path)
  end

  scenario 'User sees IT training questions when targetting a job' do
    user_targets_job
    click_on('Continue')

    expect(page).to have_current_path(it_training_questions_path)
  end

  scenario 'User sees job hunting questions when targetting a job' do
    user_targets_job
    click_on('Continue')
    click_on('Continue')

    expect(page).to have_current_path(job_hunting_questions_path)
  end

  scenario 'User navigates to action plan after going through questions' do
    user_targets_job
    click_on('Continue')
    click_on('Continue')
    click_on('Continue')

    expect(page).to have_current_path(action_plan_path)
  end

  scenario 'User does not see questions if already answered' do
    user_targets_job
    check('I need to improve my English skills', allow_label_click: true)
    click_on('Continue')
    check('I need to improve my computer skills', allow_label_click: true)
    click_on('Continue')
    check('I want advice on creating or updating a CV', allow_label_click: true)
    click_on('Continue')
    visit(job_profile_path(job_profile.slug))
    click_on('Target this type of work')

    expect(page).to have_current_path(action_plan_path)
  end

  scenario 'User does not see questions if all 3 questions already seen' do
    user_targets_job
    click_on('Continue')
    click_on('Continue')
    click_on('Continue')
    visit(job_profile_path(job_profile.slug))
    click_on('Target this type of work')

    expect(page).to have_current_path(action_plan_path)
  end

  scenario 'User sees IT training questions if only training questions already answered' do
    user_targets_job
    check('I need to improve my English skills', allow_label_click: true)
    click_on('Continue')
    visit(job_profile_path(job_profile.slug))
    click_on('Target this type of work')

    expect(page).to have_current_path(it_training_questions_path)
  end

  scenario 'User sees job hunting questions if both training and IT training questions already answered' do
    user_targets_job
    check('I need to improve my English skills', allow_label_click: true)
    click_on('Continue')
    check('I need to improve my computer skills', allow_label_click: true)
    click_on('Continue')
    visit(job_profile_path(job_profile.slug))
    click_on('Target this type of work')

    expect(page).to have_current_path(job_hunting_questions_path)
  end

  scenario 'User redirected to task list if user deep links to training questions page on a clean session' do
    visit(training_questions_path)

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'User redirected to task list if user deep links to IT training questions page on a clean session' do
    visit(it_training_questions_path)

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'User redirected to task list if user deep links to job hunting questions page on a clean session' do
    visit(job_hunting_questions_path)

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'Shows list of unselected training options' do
    user_targets_job
    visit(training_questions_path)

    expect(page).not_to have_selector('input[checked="checked"]')
  end

  scenario 'If user selects training options, options are persisted if user revisits page' do
    user_targets_job
    visit(training_questions_path)
    check('I need to improve my English skills', allow_label_click: true)
    check('I need to improve my maths skills', allow_label_click: true)
    click_on('Continue')
    visit(training_questions_path)

    expect(page).to have_selector('input[checked="checked"]', count: 2)
  end

  scenario 'If user selects training options, they get tracked in GA' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    user_targets_job
    visit(training_questions_path)
    check('I need to improve my English skills', allow_label_click: true)
    uncheck('I need to improve my maths skills', allow_label_click: true)
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
          key: :training_unticked,
          label: 'Check your maths and English skills',
          value: 'math_skills'
        }
      ]
    )
  end

  scenario 'If user selects IT training options, they get tracked in GA' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    user_targets_job
    visit(it_training_questions_path)
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

    user_targets_job
    visit(training_questions_path)
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
    )
  end

  scenario 'If user selects no IT training options, we still track those options in GA' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    user_targets_job
    visit(it_training_questions_path)
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
    )
  end

  scenario 'Shows list of unselected job hunting options' do
    user_targets_job
    visit(job_hunting_questions_path)

    expect(page).not_to have_selector('input[checked="checked"]')
  end

  scenario 'If user selects job hunting options, options are persisted if user revisits page' do
    user_targets_job
    visit(job_hunting_questions_path)
    check('I want advice on creating or updating a CV', allow_label_click: true)
    check('I want advice on preparing for interviews', allow_label_click: true)
    click_on('Continue')
    visit(job_hunting_questions_path)

    expect(page).to have_selector('input[checked="checked"]', count: 2)
  end

  scenario 'user sees progression on question pages' do
    user_targets_job
    (1..3).each do |step|
      expect(page).to have_text("Step #{step} of 3")

      click_on('Continue')
    end
  end

  scenario 'user does not see progression on question pages after reaching action plan' do
    user_targets_job
    click_on('Continue')
    click_on('Continue')
    click_on('Continue')

    {
      '1' => training_questions_path,
      '2' => it_training_questions_path,
      '3' => job_hunting_questions_path
    }.each do |step, question_page|
      visit(question_page)

      expect(page).not_to have_text("Step #{step} of 3")
    end
  end

  scenario 'user sees progression on question pages if journey interrupted' do
    user_targets_job
    click_on('Continue')
    visit(it_training_questions_path)

    (2..3).each do |step|
      expect(page).to have_text("Step #{step} of 3")

      click_on('Continue')
    end
  end

  scenario 'If user selects job hunting options, they get tracked in GA' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    user_targets_job
    visit(job_hunting_questions_path)
    check('I want advice on creating or updating a CV', allow_label_click: true)
    check('I want advice on preparing for interviews', allow_label_click: true)
    click_on('Continue')

    expect(tracking_service).to have_received(:track_events).with(
      props:
      [
        {
          key: :job_hunting_ticked,
          label: 'Get help with your job hunting skills',
          value: 'cv'
        },
        {
          key: :job_hunting_ticked,
          label: 'Get help with your job hunting skills',
          value: 'interviews'
        },
        {
          key: :job_hunting_unticked,
          label: 'Get help with your job hunting skills',
          value: 'cover_letter'
        }
      ]
    )
  end

  scenario 'If user selects no job hunting options, we still track them in GA' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    user_targets_job
    visit(job_hunting_questions_path)
    uncheck('I want advice on creating or updating a CV', allow_label_click: true)
    uncheck('I want advice on preparing for interviews', allow_label_click: true)
    uncheck('I want advice on writing a cover letter', allow_label_click: true)
    click_on('Continue')

    expect(tracking_service).to have_received(:track_events).with(
      props:
      [
        {
          key: :job_hunting_unticked,
          label: 'Get help with your job hunting skills',
          value: 'cv'
        },
        {
          key: :job_hunting_unticked,
          label: 'Get help with your job hunting skills',
          value: 'cover_letter'
        },
        {
          key: :job_hunting_unticked,
          label: 'Get help with your job hunting skills',
          value: 'interviews'
        }
      ]
    )
  end

  def user_targets_job
    visit(job_profile_path(job_profile.slug))
    click_on('Target this type of work')
  end
end
