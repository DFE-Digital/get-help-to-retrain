require 'rails_helper'

RSpec.describe Skill do
  let(:skill) { build_stubbed(:skill) }
  let(:job_profile) { build_stubbed(:job_profile) }

  describe 'relationships' do
    before do
      skill.job_profiles << job_profile
    end

    it 'has many job profiles' do
      expect(skill.job_profiles).to match [job_profile]
    end
  end

  describe '.mapping' do
    it 'maps skill id to skill name' do
      skill1 = create(:skill, name: 'Skill1')
      skill2 = create(:skill, name: 'Skill2')

      expect(described_class.mapping).to eq(
        skill1.id.to_s => 'Skill1',
        skill2.id.to_s => 'Skill2'
      )
    end

    it 'returns empty hash if there are no skills' do
      expect(described_class.mapping).to be_empty
    end
  end
end
