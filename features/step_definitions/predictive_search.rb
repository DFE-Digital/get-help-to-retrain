# TODO: revise
When('I enter at least two letters in the {string} field') do |field|
  fill_in(field, with: 'Ma')
end

# TODO: revise
Then('I should see a relevant list job titles') do
  pending # Write code here that turns the phrase above into concrete actions
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
