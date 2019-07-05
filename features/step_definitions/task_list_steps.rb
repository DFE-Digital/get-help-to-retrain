When('there are placeholders for {string}') do |string|
  case string
  when 'occupations'
    expect(page).to have_content('Explore the type of jobs you could retrain to do')
  when 'courses hub'
    expect(page).to have_content('Search for the job that you currently do to see what skills you already have')
  when 'training courses'
    expect(page).to have_content('Find and apply to training courses near you')
  when 'current course'
    expect(page).to have_content('Find out what you can do next')
  else
    "Error: occupation has an invalid value (#{string})"
  end
end
