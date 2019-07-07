Then('I should see the alternative title under the first result title') do
  find("li.govuk-\!-padding-bottom-3:nth-child(1) > p:nth-child(2)").text.should != ''
end

Then('I do not see any courses that are not listed on the list of approved providers') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I can see a list of courses') do
  expect(page).to have_selector('.pagination')
end

Then('they are sorted by distance with the shortest distance first') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I can see the details of the type of course I clicked on on the previous page') do
  pending # Write code here that turns the phrase above into concrete actions
end

Given('I am a customer at an ineligible location') do
  pending # Write code here that turns the phrase above into concrete actions
end

Given('I am a customer without a degree') do
  pending # Write code here that turns the phrase above into concrete actions
end

Given('I am a customer with a degree') do
  pending # Write code here that turns the phrase above into concrete actions
end
