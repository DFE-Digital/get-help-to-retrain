# TODO: revise
Then('there is a phone number present to contact a careers adviser') do
  expect(page).to have_content('0800 123 123')
end

# TODO: revise
Then('I can click on the phone number if I am using mobile') do
  click_link('0800 123 123')
end
