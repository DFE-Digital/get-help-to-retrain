Given("that I am on the {string} page") do |string|
    visit 'http://localhost:3000'
end
        
Then("the correct eligibility criteria is displayed") do
    expect(page).to have_content('Yay! You’re on Rails!')
end

Then("I click on the {string} link") do |string|
    click_link(string)
end
