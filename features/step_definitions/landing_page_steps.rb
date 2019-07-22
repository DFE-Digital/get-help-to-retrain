Then('the correct eligibility criteria is displayed') do
  expect(page).to have_content('you\'re employed')
  expect(page).to have_content('you don\'t have a degree')
  expect(page).to have_content('you\'re based in the Liverpool area')
  expect(page).to have_content('aged 24 or over')
  expect(page).to have_content('and you\'re earning below £35,000 a year')
end
