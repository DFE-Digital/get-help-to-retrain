When("I am on the {string} page") do |path|
  visit("/#{path}")
end

Given("I am on the homepage") do
  visit(root_path)
end

Given("a job profile exists with the name {string}") do |name|
  create(:job_profile, name: name)
end

Then("the correct eligibility criteria is displayed") do
  expect(page).to have_content('you\'re employed')
  expect(page).to have_content('you do not have a degree')
  expect(page).to have_content('you’re based in the Manchester area')
  expect(page).to have_content('aged 24 or over')
end

Then("the current page contains text {string}") do |content|
  expect(page).to have_content(content)
end

Then("I click on the button {string}") do |string|
  click(string)
end

Then("I should see all stages of the journey") do
  pending # Write code here that turns the phrase above into concrete actions
end

When("I click the text link {string}") do |string|
  click_link(string)
end

When("there are placeholders for {string}") do |string|
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

When("the link {string} is inactive") do |string|
  has_link? (string)
end

When("I enter {string} in {string} field") do |string, string2|
  fill_in string2, with: string
end

When("I click the {string} button") do |string|
  find(string).click
end

Then("I should see the {string} page") do |title|
  has_title? title
end

Then("I see error message {string}") do |error|
  expect(page).to have_content(error)
end

Then("Find a Course Service is unavailable") do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Then("Find a Course Service is available again") do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Then("I should see a list of occupations for {string}") do |string|
  case string
  when 'Healthcare'
    expect(page).to have_content('Doctor')
  when 'Administration'
    expect(page).to have_content('Secretary')
  when 'Animal Care'
    expect(page).to have_content('Vetenarian')
  else
    "Error: occupation has an invalid value (#{string})"
  end
end
