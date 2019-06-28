When("I should see list of existing skills relevant for job title") do
  expect(page.body).to have_css('ul.govuk-list li', count: 4)
end
