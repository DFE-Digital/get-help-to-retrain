Then('the correct eligibility criteria is displayed') do
  lineValues = ['you\'re employed','you do not have a degree','you\'re based in the Liverpool area','you\'re aged 24 or over','you\'re earning below £35,000 per year']

  lineValues.each do |item|
    expect(page).to have_content(item)
  end
end

