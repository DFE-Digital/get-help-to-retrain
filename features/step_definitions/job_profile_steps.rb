Given('a job profile exists with the name {string}') do |name|
  create(:job_profile, name: name)
end

Given('a job profile exists for a Construction manager') do
  create(
    :job_profile,
    :with_html_content,
    name: 'Construction manager',
    alternative_titles: 'Damage controller',
    salary_min: 27_000,
    salary_max: 70_000,
    skills: [
      create(:skill, name: 'pass enhanced background checks'),
      create(:skill, name: 'to be able to carry out basic tasks on a computer or hand-held device'),
      create(:skill, name: 'thinking and reasoning skills'),
      create(:skill, name: 'excellent verbal communication skills')
    ]
  )
end

When('I am on the {string} job profile page') do |name|
  slug = JobProfile.find_by(name: name).slug
  visit(job_profile_path(slug))
end

When('I am on the {string} job profile skills page') do |name|
  slug = JobProfile.find_by(name: name).slug
  visit(job_profile_skills_path(slug))
end

When('I can see all the information I need to learn more about that occupation') do
  expect(page.body).to have_content('Construction manager')
  expect(page.body).to have_content('Average Salary')
  expect(page.body).to have_content('Typical hours')
  expect(page.body).to have_content('You could work')
end
