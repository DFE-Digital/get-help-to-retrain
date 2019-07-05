Then('I can learn what all my next options are') do
  linevalues = ['Advice on how to look for and apply for jobs', 'Find a job', 'Find an apprenticeship']
  linevalues.each do |item|
    expect(page).to have_content(item)
  end
end
