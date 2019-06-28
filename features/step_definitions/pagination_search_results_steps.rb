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

When('I click the last page link') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I see the end of results') do
  pending # Write code here that turns the phrase above into concrete actions
end
