require 'rails_helper'
require 'support/tasks'

describe 'data_import:scrape_job_profiles', vcr: { cassette_name: 'explore_my_careers_job_profile' } do
  let(:url) { 'https://nationalcareers.service.gov.uk/job-profiles/admin-assistant' }
  let!(:job_profile) { create :job_profile, source_url: url }
  let!(:administration) { create :skill, name: 'administration skills' }
  let!(:customer_service) { create :skill, name: 'customer service skills' }

  it 'updates job profile names' do
    task.execute
    expect(job_profile.reload.name).to eq 'Admin assistant'
  end

  it 'links job profiles to skills' do
    task.execute
    expect(job_profile.skills).to include administration
    expect(job_profile.skills).to include customer_service
  end
end
