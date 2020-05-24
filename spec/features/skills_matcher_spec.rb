require 'rails_helper'

RSpec.feature 'Skills matcher', type: :feature do
  let!(:skill1) { create(:skill, name: 'Chameleon-like blend in tactics') }
  let!(:skill2) { create(:skill, name: 'License to kill') }
  let!(:skill3) { create(:skill, name: 'Baldness') }

  let!(:current_job_profile) do
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

  def visit_skills_for_current_job_profile
    visit(job_profile_skills_path(job_profile_id: current_job_profile.slug))
    click_on('Select these skills')
    click_on('Find out what you can do with these skills')
  end

  background do
    fill_pid_form

    create(:job_profile, :with_html_content, name: 'Assasin', skills: [skill1, skill2])
  end

  scenario 'User explores their occupations through skills matcher results' do
    visit_skills_for_current_job_profile
    click_on('Assasin')

    expect(page).to have_text('Chameleon-like blend in tactics')
  end

  scenario 'Redirect to tasks-list page when session is missing the job_profile_skills key' do
    visit skills_matcher_index_path

    expect(page).to have_current_path(task_list_path)
  end

  scenario 'Each section from job matches has the What does this mean? link if there is a job growth information' do
    visit_skills_for_current_job_profile

    create(:job_profile, :with_html_content, :growing, name: 'Cabin Crew', skills: [skill1, skill2])

    visit skills_matcher_index_path

    expect(page).to have_content('What does growing mean?')
  end

  scenario 'When clicking on What does this mean? link user gets the explanation for that score', :js do
    visit_skills_for_current_job_profile

    create(:job_profile, :with_html_content, :growing, name: 'Cabin Crew', skills: [skill1, skill2])

    visit skills_matcher_index_path

    find('.govuk-details__summary-text').click

    expect(page).to have_content(I18n.t(:growing, scope: :job_growth_explanation))
  end

  scenario 'returns other profiles than one selected for skills' do
    visit_skills_for_current_job_profile

    expect(page.all('ul.govuk-list li a').collect(&:text)).to eq(['Assasin'])
  end

  scenario 'does not return profiles if skills not present' do
    create(:job_profile, name: 'Hacker', skills: [skill2])
    visit(job_profile_skills_path(job_profile_id: current_job_profile.slug))
    uncheck(skill2.name, allow_label_click: true)
    click_on('Select these skills')
    click_on('Find out what you can do with these skills')

    expect(page).not_to have_text('Hacker')
  end

  scenario 'arranges profiles according to descending matching score' do
    create(:job_profile, name: 'Hacker', skills: [skill1, skill2, skill3])
    visit_skills_for_current_job_profile

    expect(page.all('ul.govuk-list li a,p:contains("Skills match")').collect(&:text)).to eq(
      ['Hacker', 'Skills match: Excellent', 'Assasin', 'Skills match: Good']
    )
  end

  scenario 'arranges profiles alphabetically if they share a score' do
    create(:job_profile, name: 'Hacker', skills: [skill2])
    create(:job_profile, name: 'Admin', skills: [skill1, skill2])
    visit_skills_for_current_job_profile

    expect(page.all('ul.govuk-list li a,p:contains("Skills match")').collect(&:text)).to eq(
      ['Admin', 'Skills match: Good', 'Assasin', 'Skills match: Good', 'Hacker', 'Skills match: Reasonable']
    )
  end

  scenario 'arranges profiles by growth if they share a score' do
    create(:job_profile, name: 'Hacker', skills: [skill1, skill2], growth: 50)
    create(:job_profile, name: 'Admin', skills: [skill1, skill2], growth: -5)
    visit_skills_for_current_job_profile

    expect(page.all('ul.govuk-list li a,p:contains("Skills match")').collect(&:text)).to eq(
      ['Hacker', 'Skills match: Good', 'Admin', 'Skills match: Good', 'Assasin', 'Skills match: Good']
    )
  end

  scenario 'arranges profiles by growth, then alphabetically if they share a score' do
    create(:job_profile, name: 'Hitman', skills: [skill1, skill2], growth: 50)
    create(:job_profile, name: 'Hacker', skills: [skill1, skill2], growth: 50)
    create(:job_profile, name: 'Admin', skills: [skill1, skill2], growth: -5)
    visit_skills_for_current_job_profile

    expect(page.all('ul.govuk-list li a,p:contains("Skills match")').collect(&:text)).to eq(
      ['Hacker', 'Skills match: Good', 'Hitman', 'Skills match: Good', 'Admin', 'Skills match: Good', 'Assasin', 'Skills match: Good']
    )
  end

  scenario 'allows profiles to be optionally sorted by growth' do
    create(:job_profile, name: 'Hacker', skills: [skill1, skill2], growth: -5)
    create(:job_profile, name: 'Admin', skills: [skill1], growth: 50)
    visit_skills_for_current_job_profile

    visit skills_matcher_index_path(sort: 'growth')

    expect(page.all('ul.govuk-list li a,p:contains("Skills match")').collect(&:text)).to eq(
      ['Admin', 'Skills match: Reasonable', 'Hacker', 'Skills match: Good', 'Assasin', 'Skills match: Good']
    )
  end

  scenario 'automatically reloads results when sort order changed', :js do
    visit_skills_for_current_job_profile

    find("option[value='growth']").click

    expect(page).to have_current_path(skills_matcher_index_path(sort: 'growth'))
  end

  scenario 'defaults sort order to skills match if not specified', :js do
    visit_skills_for_current_job_profile

    expect(page).to have_select('sort-select', selected: 'Skills match')
  end

  scenario 'preserves selected sort order when returning to page', :js do
    visit_skills_for_current_job_profile

    find("option[value='growth']").click

    visit task_list_path
    visit skills_matcher_index_path

    expect(page).to have_select('sort-select', selected: 'Recent job growth')
  end

  scenario 'passes along the search query string when sorting if present', :js do
    visit_skills_for_current_job_profile

    visit skills_matcher_index_path(search: 'therapy')

    find("option[value='growth']").click

    expect(page).to have_current_path('/job-matches?sort=growth&search=therapy')
  end

  scenario 'does not pass along the search query string when sorting if absent', :js do
    visit_skills_for_current_job_profile

    visit skills_matcher_index_path

    find("option[value='growth']").click

    expect(page).to have_current_path(skills_matcher_index_path(sort: 'growth'))
  end

  scenario 'paginates results of search' do
    create_list(:job_profile, 12, name: 'Hacker', skills: [skill1])
    visit_skills_for_current_job_profile

    expect(page).to have_selector('ul.govuk-list li', count: 10)
  end

  scenario 'allows user to paginate through results' do
    create_list(:job_profile, 11, name: 'Hacker', skills: [skill1])
    visit_skills_for_current_job_profile
    click_on('Next')

    expect(page).to have_selector('ul.govuk-list li', count: 2)
  end

  scenario 'returns no results if no job profiles match skills search' do
    job_profile = create(:job_profile, name: 'Admin', skills: [create(:skill)])
    visit(job_profile_skills_path(job_profile_id: job_profile.slug))
    click_on('Select these skills')
    click_on('Find out what you can do with these skills')

    expect(page).to have_text('0 results found')
  end

  scenario 'search for unknown job title shows no results' do
    visit_skills_for_current_job_profile

    visit skills_matcher_index_path
    click_on('Search by job title')

    fill_in('search', with: 'Escapologist')
    find('.search-button').click

    expect(page).to have_text('0 results found')
  end

  scenario 'search for specific job title shows number of results' do
    visit_skills_for_current_job_profile

    create(:job_profile, :with_html_content, :growing, name: 'Florist')

    visit skills_matcher_index_path
    click_on('Search by job title')

    fill_in('search', with: 'florist')
    find('.search-button').click

    expect(page).to have_text('1 result found')
  end

  scenario 'Error summary message present if no search is entered on job search page' do
    visit_skills_for_current_job_profile

    visit job_profiles_path
    find('.search-button').click

    expect(page).to have_content('There is a problem')
  end

  scenario 'Error summary contains error if no search is entered on job search page' do
    visit_skills_for_current_job_profile

    visit job_profiles_path
    find('.search-button').click

    expect(page.all('ul.govuk-error-summary__list li a').collect(&:text)).to eq(
      [
        'Enter a job title'
      ]
    )
  end

  scenario 'Error summary message present if no search is entered on job results page' do
    visit_skills_for_current_job_profile
    visit(results_job_profiles_path(search: ''))

    expect(page).to have_content('There is a problem')
  end

  scenario 'Error summary contains error if no search is entered on job results page' do
    visit_skills_for_current_job_profile
    visit(results_job_profiles_path(search: ''))

    expect(page.all('ul.govuk-error-summary__list li a').collect(&:text)).to eq(
      [
        'Enter a job title'
      ]
    )
  end

  scenario 'The search query string param is passed along to your matches page if present' do
    visit_skills_for_current_job_profile
    visit(results_job_profiles_path(search: 'therapy'))

    click_on('Your matches')

    expect(page).to have_current_path(skills_matcher_index_path(search: 'therapy'))
  end

  scenario 'The search query string param is not passed along to your matches page if absent' do
    visit_skills_for_current_job_profile
    visit(job_profiles_path)

    click_on('Your matches')

    expect(page).to have_current_path(skills_matcher_index_path)
  end

  scenario 'search for specific job title shows skills match' do
    visit_skills_for_current_job_profile

    create(:job_profile, :with_html_content, name: 'Florist', skills: [skill3])

    visit skills_matcher_index_path
    click_on('Search by job title')

    fill_in('search', with: 'florist')
    find('.search-button').click

    expect(page.all('ul.govuk-list li a,p:contains("Skills match")').collect(&:text)).to eq(
      ['Florist', 'Skills match: Reasonable']
    )
  end

  scenario 'search for specific job title shows no skills matching' do
    visit_skills_for_current_job_profile

    create(:job_profile, :with_html_content, name: 'Florist')

    visit skills_matcher_index_path
    click_on('Search by job title')

    fill_in('search', with: 'florist')
    find('.search-button').click

    expect(page.all('ul.govuk-list li a,p:contains("Skills match")').collect(&:text)).to eq(
      ['Florist', 'Skills match: None']
    )
  end

  scenario 'search for specific job title allows clicking through to job profile page' do
    visit_skills_for_current_job_profile

    create(:job_profile, :with_html_content, name: 'Fluffer', slug: 'fluffer')

    visit skills_matcher_index_path
    click_on('Search by job title')

    fill_in('search', with: 'fluffer')
    find('.search-button').click
    click_on('Fluffer')

    expect(page).to have_current_path(job_profile_path('fluffer'))
  end

  scenario 'search query string param is passed to job profiles search page if present' do
    visit_skills_for_current_job_profile

    visit skills_matcher_index_path(search: 'therapy')

    click_on('Search by job title')

    expect(page).to have_current_path(results_job_profiles_path(search: 'therapy'))
  end

  scenario 'no search query string param is passed to job profiles search page if missing' do
    visit_skills_for_current_job_profile

    visit skills_matcher_index_path

    click_on('Search by job title')

    expect(page).to have_current_path(job_profiles_path)
  end

  scenario 'tracks search string in job profile search' do
    tracking_service = instance_spy(TrackingService)
    allow(TrackingService).to receive(:new).and_return(tracking_service)
    visit_skills_for_current_job_profile

    visit(skills_matcher_index_path)
    click_on('Search by job title')

    fill_in('search', with: 'fluffer')
    find('.search-button').click

    expect(tracking_service).to have_received(:track_events).with(
      props:
      [
        {
          key: :job_profiles_index_search,
          label: 'Job profiles - Job search',
          value: 'fluffer'
        }
      ]
    )
  end

  scenario 'User enters an incorrect word on job profiles page but no spell check api key is available' do
    allow(Rails.configuration).to receive(:bing_spell_check_api_endpoint).and_return('https://s111-bingspellcheck.cognitiveservices.azure.com/bing/v7.0/spellcheck')
    allow(Rails.configuration).to receive(:bing_spell_check_api_key).and_return(nil)

    visit_skills_for_current_job_profile
    visit(job_profiles_path)

    fill_in('search', with: 'Gatas')
    find('.search-button').click

    expect(page).not_to have_text('Did you mean')
  end

  scenario 'User enters an incorrect word on job profiles page but no spell check api endpoint is available' do
    allow(Rails.configuration).to receive(:bing_spell_check_api_key).and_return('test')
    allow(Rails.configuration).to receive(:bing_spell_check_api_endpoint).and_return(nil)

    visit_skills_for_current_job_profile
    visit(job_profiles_path)

    fill_in('search', with: 'Gatas')
    find('.search-button').click

    expect(page).not_to have_text('Did you mean')
  end

  scenario 'User enters an incorrect word on job profiles page and a correction is returned' do
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

    visit_skills_for_current_job_profile
    visit(job_profiles_path)

    fill_in('search', with: 'Gatas')
    find('.search-button').click

    expect(page).to have_text('Did you mean gates')
  end

  scenario 'User enters an incorrect word on job profiles page and the correction leads to results page' do
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

    visit_skills_for_current_job_profile
    visit(job_profiles_path)

    fill_in('search', with: 'Gatas')
    find('.search-button').click
    fake_bing_api_call_with(no_correction_response_body, 'gates')
    click_on('gates')

    expect(page).to have_current_path(results_job_profiles_path(search: 'gates'))
  end

  scenario 'User enters an incorrect word on job profiles page but sees no correction' do
    stub_bing_api_keys

    response_body = {
      '_type': 'SpellCheck',
      'flaggedTokens': []
    }.to_json

    fake_bing_api_call_with(response_body, 'Gatas')

    visit_skills_for_current_job_profile
    visit(job_profiles_path)

    fill_in('search', with: 'Gatas')
    find('.search-button').click

    expect(page).not_to have_text('Did you mean gates')
  end
end
