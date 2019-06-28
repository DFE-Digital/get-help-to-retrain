Then('I see error message {string}') do |error|
  expect(page).to have_content(error)
end
