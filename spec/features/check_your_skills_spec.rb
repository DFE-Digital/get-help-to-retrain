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

  def fake_bing_api_call_with(response_body, text)
    request_headers = {
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Ocp-Apim-Subscription-Key' => 'test'
    }

    stub_request(:get, SpellCheckService::API_ENDPOINT)
      .with(headers: request_headers,
            query: URI.encode_www_form(mkt: 'en-gb', mode: 'spell', text: text))
      .to_return(body: response_body, status: 200)
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

    expect(page).to have_text('Your current job')
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

    expect(page).to have_text('Your previous job')
  end

  scenario 'User enters an incorrect word but no api key is available' do
    visit(check_your_skills_path)
    fill_in('search', with: 'Gatas')
    find('.search-button').click

    expect(page).not_to have_text('Did you mean')
  end

  scenario 'User enters an incorrect word and a correction is returned' do
    Rails.configuration.bing_spell_check_api_key = 'test'
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
  ensure
    Rails.configuration.bing_spell_check_api_key = nil
  end

  scenario 'User enters an incorrect word and the correction leads to results page' do
    Rails.configuration.bing_spell_check_api_key = 'test'
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
  ensure
    Rails.configuration.bing_spell_check_api_key = nil
  end

  scenario 'User enters an incorrect word but sees no correction' do
    Rails.configuration.bing_spell_check_api_key = 'test'
    response_body = {
      '_type': 'SpellCheck',
      'flaggedTokens': []
    }.to_json

    fake_bing_api_call_with(response_body, 'Gatas')

    visit(check_your_skills_path)
    fill_in('search', with: 'Gatas')
    find('.search-button').click

    expect(page).not_to have_text('Did you mean gates')
  ensure
    Rails.configuration.bing_spell_check_api_key = nil
  end

  scenario 'User cannot find occupation through search' do
    visit(check_your_skills_path)
    fill_in('search', with: 'Embalmer')
    find('.search-button').click

    expect(page).to have_text('No results found')
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

    expect(page).to have_text('Your current job')
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
