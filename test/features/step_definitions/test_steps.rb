Given("that I am on the {string} page") do |string|
    visit 'http://localhost:3000'
end
        
Then("the correct eligibility criteria is displayed") do
    expect(page).to have_content('Yay! You’re on Rails!')
end

Then("the current page contains text {string}") do |string|
    expect(page).to have_content(string)
end

Then("I click on the link text {string}") do |string|
    click_link(string)
end

Then("I click on the button {string}") do |string|
    click(string)
end
