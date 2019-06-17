Given("I am on the {string} page") do |string|
    visit 'http://localhost:3000/pages/' + string
end
        
Then("the correct eligibility criteria is displayed") do
    expect(page).to have_content('Yay! You’re on Rails!')
end

Then("the current page contains text {string}") do |string|
    expect(page).to have_content(string)
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
        expect(page).to have_content('occupation')
    else
      "Error: occupation has an invalid value (#{string})"
    end
end

When("the link {string} is inactive") do |string|
    has_link? (string)
end

When("I enter {string} in {string} field") do |string, string2|
    fill_in string, with: string2
end

When("I click the {string} button") do |string|
    click_button(string)
end

Then("I should see the {string} page") do |string|
    page.has_title? string
end

Then("I see error message {string}") do |string|
    expect(page).to have_content(string)
end

Then("Find a Course Service is unavailable") do |string|
    service httpd stop
end

Then("Find a Course Service is available again") do |string|
    service httpd start
end

Then("I should see a list of occupations for {string}") do |string|
    case string
    when 'Healthcare'
        expect(page).to have_content('Doctor')
    else
      "Error: occupation has an invalid value (#{string})"
    end
end
