Given(/^I am on the homepage$/) do
  visit(root_path)
end

When(/^I click on "(.*?)"$/) do |txt|
  click_on(txt)
end

Then(/^I should see "(.*?)"$/) do |text|
  expect(page.body).to match(CGI.escapeHTML(text))
end

When(/^I am on the "(.*?)" page$/) do |path|
  visit("/#{path}")
end

When(/^I fill in "(.*?)" with "(.*?)"$/) do |field, content|
  fill_in(field, with: content)
end

When(/^I click the "(.*?)" button$/) do |identifier|
  find(identifier).click
end

Given(/^the following job profiles are available$/) do |table|
  table.hashes.each do |row|
    name = row.fetch('Name')

    create(:job_profile, name: name)
  end
end
