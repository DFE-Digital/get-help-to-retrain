require 'rails_helper'

RSpec.feature 'Check your skills', type: :feature do
  background do
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
    fill_in('search', with: 'Bodyguard')
    find('.search-button').click
    click_on('Bodyguard')

    expect(page).to have_text('Patience and the ability to remain calm in stressful situations')
  end

  scenario 'When user adds the first job the results page should reflect that' do
    visit(check_your_skills_path)
    fill_in('search', with: 'Bodyguard')
    find('.search-button').click

    expect(page).to have_text('Tell us your current job title')
  end

  scenario 'When user tries adding the first job but finds no results' do
    visit(check_your_skills_path)
    fill_in('search', with: 'Some weird title nobody would find')
    find('.search-button').click

    ['Tell us your current job title', 'We can\'t find any results for this job title.'].each do |text|
      expect(page).to have_text(text)
    end
  end

  scenario 'When user adds previous job titles the results page should reflect that' do
    hitman = create(
      :job_profile,
      :with_html_content,
      name: 'Hitman5',
      skills: [
        create(:skill)
      ]
    )
    visit(job_profile_skills_path(job_profile_id: hitman.slug))
    click_on('Select these skills')
    visit(check_your_skills_path)
    fill_in('search', with: 'Bodyguard')
    find('.search-button').click

    expect(page).to have_text('Tell us your previous job title')
  end

  scenario 'When user tries adding a previous job title but no results are found' do
    hitman = create(
      :job_profile,
      :with_html_content,
      name: 'Hitman5',
      skills: [
        create(:skill)
      ]
    )
    visit(job_profile_skills_path(job_profile_id: hitman.slug))
    click_on('Select these skills')
    visit(check_your_skills_path)
    fill_in('search', with: 'A weird title that doesn not exist')
    find('.search-button').click

    ['Tell us your previous job title', 'We can\'t find any results for this job title.'].each do |text|
      expect(page).to have_text(text)
    end
  end

  scenario 'User enters an incorrect word but no api key is available' do
    allow(Rails.configuration).to receive(:bing_spell_check_api_endpoint).and_return('https://s111-bingspellcheck.cognitiveservices.azure.com/bing/v7.0/spellcheck')
    allow(Rails.configuration).to receive(:bing_spell_check_api_key).and_return(nil)

    visit(check_your_skills_path)
    fill_in('search', with: 'Gatas')
    find('.search-button').click

    expect(page).not_to have_text('Did you mean')
  end

  scenario 'User enters an incorrect word but no api endpoint is available' do
    allow(Rails.configuration).to receive(:bing_spell_check_api_key).and_return('test')
    allow(Rails.configuration).to receive(:bing_spell_check_api_endpoint).and_return(nil)

    visit(check_your_skills_path)
    fill_in('search', with: 'Gatas')
    find('.search-button').click

    expect(page).not_to have_text('Did you mean')
  end

  scenario 'User enters an incorrect word and a correction is returned' do
    stub_bing_api_keys

    response_body = {
      '_type': 'SpellCheck',
      'flaggedTokens': [
        {
          'offset': 5,
          'token': 'Gatas',
          'type': 'UnknownToken',
          'suggestions': [
            {
              'suggestion': 'Gates',
              'score': 1
            }
          ]
        }
      ]
    }.to_json

    fake_bing_api_call_with(response_body, 'Gatas')

    visit(check_your_skills_path)
    fill_in('search', with: 'Gatas')
    find('.search-button').click

    expect(page).to have_text('Did you mean gates')
  end

  scenario 'User enters an incorrect word and the correction leads to results page' do
    stub_bing_api_keys

    correction_response_body = {
      '_type': 'SpellCheck',
      'flaggedTokens': [
        {
          'offset': 5,
          'token': 'Gatas',
          'type': 'UnknownToken',
          'suggestions': [
            {
              'suggestion': 'Gates',
              'score': 1
            }
          ]
        }
      ]
    }.to_json
    no_correction_response_body = {
      '_type': 'SpellCheck',
      'flaggedTokens': []
    }.to_json

    fake_bing_api_call_with(correction_response_body, 'Gatas')

    visit(check_your_skills_path)
    fill_in('search', with: 'Gatas')
    find('.search-button').click
    fake_bing_api_call_with(no_correction_response_body, 'gates')
    click_on('gates')

    expect(page).to have_current_path(results_check_your_skills_path(search: 'gates'))
  end

  scenario 'User enters an incorrect word but sees no correction' do
    stub_bing_api_keys

    response_body = {
      '_type': 'SpellCheck',
      'flaggedTokens': []
    }.to_json

    fake_bing_api_call_with(response_body, 'Gatas')

    visit(check_your_skills_path)
    fill_in('search', with: 'Gatas')
    find('.search-button').click

    expect(page).not_to have_text('Did you mean gates')
  end

  scenario 'User cannot find occupation through search' do
    visit(check_your_skills_path)
    fill_in('search', with: 'Embalmer')
    find('.search-button').click

    expect(page).to have_text('We can\'t find any results for this job title.')
  end

  scenario 'tracks search string' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)

    visit(check_your_skills_path)
    fill_in('search', with: 'Bodyguard')
    find('.search-button').click

    expect(tracking_service).to have_received(:track_events).with(
      props:
      [
        {
          key: :check_your_skills_index_search,
          label: 'Check your skills - Job search',
          value: 'Bodyguard'
        }
      ]
    )
  end

  scenario 'when TrackingService errors, user journey is not affected' do
    tracking_service = instance_double(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)
    allow(tracking_service).to receive(:track_events).and_raise(TrackingService::TrackingServiceError)

    visit(check_your_skills_path)
    fill_in('search', with: 'Bodyguard')
    find('.search-button').click

    expect(page).to have_text('Tell us your current job title')
  end

  scenario 'paginates results of search' do
    create_list(:job_profile, 12, name: 'Hacker')
    visit(check_your_skills_path)
    fill_in('search', with: 'Hacker')
    find('.search-button').click

    expect(page).to have_selector('ul.govuk-list li', count: 10)
  end

  scenario 'allows user to paginate through results' do
    create_list(:job_profile, 12, name: 'Hacker')
    visit(check_your_skills_path)
    fill_in('search', with: 'Hacker')
    find('.search-button').click
    click_on('Next')

    expect(page).to have_selector('ul.govuk-list li', count: 2)
  end

  scenario 'User gets relevant messaging if no search is entered' do
    visit(check_your_skills_path)
    find('.search-button').click

    expect(page).to have_text(/Enter a job title/)
  end

  scenario 'Error summary message present if no search is entered' do
    visit(check_your_skills_path)
    find('.search-button').click

    expect(page).to have_content('There is a problem')
  end

  scenario 'Error summary contains error if no search is entered' do
    visit(check_your_skills_path)
    find('.search-button').click

    expect(page.all('ul.govuk-error-summary__list li a').collect(&:text)).to eq(
      [
        'Enter a job title'
      ]
    )
  end

  scenario 'User gets relevant messaging if no search in results is entered' do
    create(:job_profile, name: 'Hacker')
    visit(results_check_your_skills_path(search: 'Hacker'))
    fill_in('search', with: '')
    find('.search-button').click

    expect(page).to have_text(/Enter a job title/)
  end

  scenario 'Error summary message present if no search is entered on results page' do
    visit(results_check_your_skills_path(search: ''))

    expect(page).to have_content('There is a problem')
  end

  scenario 'Error summary contains error if no search is entered on results page' do
    visit(results_check_your_skills_path(search: ''))

    expect(page.all('ul.govuk-error-summary__list li a').collect(&:text)).to eq(
      [
        'Enter a job title'
      ]
    )
  end
end
