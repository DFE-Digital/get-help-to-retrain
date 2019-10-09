require 'rails_helper'

RSpec.feature 'Check your skills', type: :feature do
  background do
    disable_feature! :spell_check

    create(
      :job_profile,
      name: 'Bodyguard',
      skills: [
        create(:skill, name: 'Patience and the ability to remain calm in stressful situations')
      ]
    )
  end

  def fake_bing_api_call_with(response_body)
    request_headers = {
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Ocp-Apim-Subscription-Key' => 'test'
    }

    stub_request(:get, SpellCheckService::API_ENDPOINT)
      .with(headers: request_headers,
            query: URI.encode_www_form(mkt: 'en-gb', mode: 'spell', text: 'Gatas'))
      .to_return(body: response_body, status: 200)
  end

  scenario 'User checks their current skills' do
    visit(check_your_skills_path)
    fill_in('search', with: 'Bodyguard')
    find('.search-button').click
    click_on('Bodyguard')

    expect(page).to have_text('Patience and the ability to remain calm in stressful situations')
  end

  scenario 'Spell check feature is OFF - no correction visible' do
    visit(check_your_skills_path)
    fill_in('search', with: 'Bodyguard')
    find('.search-button').click

    expect(page).not_to have_text('Did you mean')
  end

  scenario 'Spell check feature is ON - but no key is given' do
    enable_feature! :spell_check

    visit(check_your_skills_path)
    fill_in('search', with: 'Bodyguard')
    find('.search-button').click

    expect(page).not_to have_text('Did you mean')
  end

  scenario 'Spell check feature is ON - and a correction is returned' do
    enable_feature! :spell_check

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

    fake_bing_api_call_with(response_body)

    visit(check_your_skills_path)
    fill_in('search', with: 'Gatas')
    find('.search-button').click

    expect(page).to have_text('Did you mean gates')
  end

  scenario 'Spell check feature is ON - the correction leads to results page' do
    enable_feature! :spell_check

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

    fake_bing_api_call_with(response_body)

    visit(check_your_skills_path)
    fill_in('search', with: 'Gatas')
    find('.search-button').click

    click_on('gates')

    expect(page).to have_current_path(results_check_your_skills_path(search: 'gates'))
  end

  scenario 'Spell check feature is ON - and no correction is returned' do
    enable_feature! :spell_check

    response_body = {
      '_type': 'SpellCheck',
      'flaggedTokens': []
    }.to_json

    fake_bing_api_call_with(response_body)

    visit(check_your_skills_path)
    fill_in('search', with: 'Gates')
    find('.search-button').click

    expect(page).not_to have_text('Did you mean Gates')
  end

  scenario 'User cannot find occupation through search' do
    visit(check_your_skills_path)
    fill_in('search', with: 'Embalmer')
    find('.search-button').click

    expect(page).to have_text('No results found')
  end

  scenario 'tracks search string' do
    allow(TrackingService).to receive(:track_event)

    visit(check_your_skills_path)
    fill_in('search', with: 'Bodyguard')
    find('.search-button').click

    expect(TrackingService).to have_received(:track_event).with('Check your skills - Job search', search: 'Bodyguard')
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

  scenario 'User gets relevant messaging if no search in results is entered' do
    create(:job_profile, name: 'Hacker')
    visit(results_check_your_skills_path(search: 'Hacker'))
    fill_in('search', with: '')
    find('.search-button').click

    expect(page).to have_text(/Enter a job title/)
  end
end
