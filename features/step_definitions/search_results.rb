Then('I should see the alternative titles under the first result title') do
  expect(page).to have_field('p.govuk-body-s:nth-child(2)', with: /.+/) 
end
