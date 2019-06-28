Then('I can learn what all my next options are') do
  expect(page.body).to have_content('Advice on how to look for and apply for jobs')
  expect(page.body).to have_content('Find a job')
  expect(page.body).to have_content('Find an apprenticeship')
end
