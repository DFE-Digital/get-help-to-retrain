# TODO: revise
When('I enter at least two letters of a {string} field') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see a relevant list of job titles') do
  expect(page).to have_selector('.job-titles')
end

When('I click on a first job title') do
  find('.job-result-1').click
end

Then('I should not see a relevant list of job titles') do
  expect(page).not_to have_selector('.pagination')
end

# TODO: revise
When('I click on a random job title') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see the {string} page') do |path|
  expect(page.current_path).to have_current_path(path)
end

Then('I should see the related occupations') do
  find('h2.govuk-heading-m').visible?
end
