require 'rails_helper'
require 'support/tasks'

RSpec.describe 'data_import:refresh_job_profiles' do
  let!(:useful_skill) { create :skill, name: 'Space walking' }
  let!(:useless_skill) { create :skill, name: 'Deckchair rearranging' }
  let!(:astronaut) { create :job_profile, :with_html_content, slug: 'astronaut', skills: [useful_skill] }
  let!(:captain) { create :job_profile, :with_html_content, slug: 'captain' }

  it 'removes redundant existing skills that are not present in scraped content' do
    captain.skills << useless_skill

    expect {
      task.execute
    }.to change(JobProfileSkill, :count).from(2).to(1)
  end

  it 'removes orphan existing skills that are not linked to job profiles' do
    expect {
      task.execute
    }.to change(Skill, :count).from(2).to(1)
  end

  it 'populates job profile skills from parsing scraped content' do
    task.execute

    expect(astronaut.reload.skills).to contain_exactly(useful_skill)
  end
end
