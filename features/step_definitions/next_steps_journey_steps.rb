Then('I can learn what all my next options are') do
lineValues = ['Advice on how to look for and apply for jobs','Find a job','Find an apprenticeship']
  lineValues.each do |item|
    expect(page).to have_content(item)
  end
end
