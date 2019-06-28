Then('the correct eligibility criteria is displayed') do
  expect(page).to have_content('you\'re employed')
  expect(page).to have_content('you do not have a degree')
  expect(page).to have_content('you’re based in the Manchester area')
  expect(page).to have_content('aged 24 or over')
end
