# TODO: revise
Then('there is a phone number present to contact a careers adviser') do
  within('.govuk-related-items') { expect(page).to have_content('0800 051 0459') }
end

# TODO: revise
Then('I can click on the phone number if I am using mobile') do
  page.assert_selector(:css, 'a[href="tel:00448000510459"]')
end
