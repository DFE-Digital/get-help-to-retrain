# TODO: revise example step creates multiple instances of job profile
Given('there exists {string} results for the job profile {string}') do |number, name|
  create_list(:job_profile, number.to_i, name: name)
end

# TODO: revise example step uses multiple steps
Given('I have searched for the occupation {string}') do |name|
  steps %(
    Given I enter "#{name}" in "name" field
    And I click the ".search-button" button
  )
end

Given('that I search existing skills that results in less than one page of results') do
  fill_in 'name', with: 'manager'
  find('button.search-button').click
end

Given('that I search by job title that results in more than one page of results') do
  fill_in 'name', with: 'manager'
  find('button.search-button').click
end

Given('that I search by job title that results in less than one page of results') do
  fill_in 'name', with: 'manager'
  find('button.search-button').click
end

Then('I should see the pagination on the page') do
  expect(page).to have_selector('.pagination')
end

Then('I should not see the pagination on the page') do
  expect(page).not_to have_selector('.pagination')
end

Given('that I search existing skills that results in more than one page of results') do
  visit('/check_your_skills')
  fill_in 'name', with: 'manager'
  find('button.search-button').click
end

# TODO: revise
When('I click the last page link') do
  pending # Write code here that turns the phrase above into concrete actions
end

# TODO: revise
Then('I see the end of results') do
  pending # Write code here that turns the phrase above into concrete actions
end
