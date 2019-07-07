Given('I am on the homepage') do
  visit(root_path)
end

When('I am on the {string} page') do |path|
  visit("/#{path}")
end

When('the current url path is {string}') do |path|
  expect(page.current_path).to have_current_path(path)
end

Then('I should see {string}') do |text|
  expect(page.body).to match(CGI.escapeHTML(text))
end

Then('I should not see {string}') do |text|
  expect(page.body).not_to match(CGI.escapeHTML(text))
end

When('I enter {string} in {string} field') do |content, field|
  fill_in(field, with: content)
end

When('I click the {string} button') do |identifier|
  find(identifier).click
end

When('I click on {string}') do |string|
  click_link(string)
end

Given('the following job profiles are available') do |table|
  table.hashes.each do |row|
    name = row.fetch('Name')
    category_name = row.fetch('Category')
    category = Category.find_by(name: category_name)

    create(:job_profile, name: name, categories: [category])
  end
end

Given('the following categories are available') do |table|
  table.hashes.each do |row|
    name = row.fetch('Name')
    create(:category, name: name)
  end
end

Then('I should see error {string}') do |string|
  expect(page).to have_content(string)
end

# TODO: revise
# When('the link {string} is inactive') do |string|
#   has_link? string
# end

# TODO: revise
# Given("there is user with criteria:") do |table|
#   print "todo: need to define test data"
# end
