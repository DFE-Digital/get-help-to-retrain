Given('a job profile exists with the name {string}') do |name|
  create(:job_profile, name: name)
end

Given('a job profile exists for a Construction manager') do
  content = Rails.root.join('features', 'fixtures', 'construction_manager_content.html').read
  create(
    :job_profile,
    name: 'Construction manager',
    content: content,
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
  visit("/job_profiles/#{slug}")
end

When('I am on the {string} job profile skills page') do |name|
  slug = JobProfile.find_by(name: name).slug
  visit("/job_profiles/#{slug}/skills")
end

