require 'rails_helper'
require 'support/tasks'

RSpec.describe 'data_import:update_skills_rarity' do
  let(:unique_skill) { create(:skill) }
  let(:rare_skill) { create(:skill) }
  let(:common_skill) { create(:skill) }
  let(:orphan_skill) { create(:skill) }
  let(:all_skills) { [unique_skill, rare_skill, common_skill, orphan_skill] }

  before do
    create(:job_profile, skills: [unique_skill, rare_skill, common_skill])
    create(:job_profile, skills: [rare_skill, common_skill])
    create(:job_profile, skills: [common_skill])
  end

  it 'calculates correct rarity for every skill' do
    task.execute
    all_skills.map(&:reload)
    expect(all_skills.map(&:rarity)).to eq [1, 2, 3, nil]
  end
end
