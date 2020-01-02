require 'rails_helper'

RSpec.describe JobProfileSkill do
  describe '.update_rarity' do
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
      described_class.update_rarity
      all_skills.map(&:reload)
      expect(all_skills.map(&:rarity)).to eq [1, 2, 3, nil]
    end
  end
end
