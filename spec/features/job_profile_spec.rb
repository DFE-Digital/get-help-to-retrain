require 'rails_helper'

RSpec.feature 'Job profile spec' do
  scenario 'Page title has the structure: What does a typical <job_profile.name> do?' do
    create(:job_profile, :with_html_content, name: 'Cleric', slug: 'cleric')

    visit(job_profile_path('cleric'))

    expect(page).to have_content('What does a typical Cleric do?')
  end

  scenario 'Alternative titles has the structure Other similar jobs include: xxxxx' do
    job_profile = create(:job_profile, :with_html_content, alternative_titles: 'Therapy master, dog walker, trainer')

    visit(job_profile_path(job_profile.slug))

    expect(page).to have_content('Other similar jobs include: therapy master, dog walker, trainer')
  end

  scenario 'Page contains the Valuable skills section' do
    job_profile = create(:job_profile, :with_html_content)

    visit(job_profile_path(job_profile.slug))

    expect(page).to have_content('Valuable skills')
  end

  scenario 'User navigates to training hub page from valuable skills section' do
    job_profile = create(:job_profile, :with_html_content)

    visit(job_profile_path(job_profile.slug))

    click_on('Find a training course')

    expect(page).to have_current_path(training_hub_path)
  end

  scenario 'Page contains the Further help to change jobs section' do
    job_profile = create(:job_profile, :with_html_content)

    visit(job_profile_path(job_profile.slug))

    expect(page).to have_content('Further help to change jobs')
  end

  scenario 'User navigates to next steps page from valuable skills section' do
    job_profile = create(:job_profile, :with_html_content)

    visit(job_profile_path(job_profile.slug))

    click_on('Get help changing jobs')

    expect(page).to have_current_path(next_steps_path)
  end

  scenario 'Apprenticeship section is not rendered unless it exists' do
    job_profile = create(:job_profile, :with_html_content)

    visit(job_profile_path(job_profile.slug))

    expect(page).not_to have_content('Apprenticeship')
  end
end
