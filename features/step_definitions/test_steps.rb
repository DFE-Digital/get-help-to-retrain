Then('the correct eligibility criteria is displayed') do
  expect(page).to have_content('you\'re employed')
  expect(page).to have_content('you do not have a degree')
  expect(page).to have_content('you’re based in the Manchester area')
  expect(page).to have_content('aged 24 or over')
end

Then('I should see all stages of the journey') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('there are placeholders for {string}') do |string|
  case string
  when 'occupations'
    expect(page).to have_content('Explore the type of jobs you could retrain to do')
  when 'courses hub'
    expect(page).to have_content('Search for the job that you currently do to see what skills you already have')
  when 'training courses'
    expect(page).to have_content('Find and apply to training courses near you')
  when 'current course'
    expect(page).to have_content('Find out what you can do next')
  else
    "Error: occupation has an invalid value (#{string})"
  end
end

When('the link {string} is inactive') do |string|
  has_link? string
end

When('I enter {string} in {string} field') do |string, string2|
  fill_in string2, with: string
end

Then('I see error message {string}') do |error|
  expect(page).to have_content(error)
end

Then('Find a Course Service is unavailable') do |_string|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('Find a Course Service is available again') do |_string|
  pending # Write code here that turns the phrase above into concrete actions
end

Given("there is user with criteria:") do |table|
  print "todo: need to define test data"
end

Given("that I search existing skills that results in less than one page of results") do
  fill_in 'name', with: 'manager'
  find('button.search-button').click
end

Given("that I search by job title that results in more than one page of results") do
  fill_in 'name', with: 'manager'
  find('button.search-button').click
end

Given("that I search by job title that results in less than one page of results") do
  fill_in 'name', with: 'manager'
  find('button.search-button').click
end

Then("I should see the pagination on the page") do
  expect(page).to have_selector(".pagination")
end

Then("I should not see the pagination on the page") do
  expect(page).not_to have_selector(".pagination")
end

Given("that I search existing skills that results in more than one page of results") do
  visit("/check_your_skills")
  fill_in 'name', with: 'manager'
  find('button.search-button').click
end

When("I should see list of existing skills relevant for job title") do
  find('ul.govuk-list')
end
