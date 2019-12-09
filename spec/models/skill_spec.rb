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

  describe '#names_that_include' do
    it 'returns skill names that only match included ids' do
      skill1 = create(:skill, name: 'Skill1')
      create(:skill, name: 'Skill2')

      expect(described_class.names_that_include(skill1.id.to_s)).to contain_exactly(
        skill1.name
      )
    end

    it 'returns nothing if no ids intersect' do
      create(:skill, name: 'Skill1')

      expect(described_class.names_that_include('09990')).to be_empty
    end

    it 'returns nothing if there are no skills' do
      expect(described_class.names_that_include('1')).to be_empty
    end
  end

  describe '#names_that_exclude' do
    it 'returns skill names that do not match included ids' do
      skill1 = create(:skill, name: 'Skill1')
      skill2 = create(:skill, name: 'Skill2')

      expect(described_class.names_that_exclude(skill1.id.to_s)).to contain_exactly(
        skill2.name
      )
    end

    it 'returns all skill names if excluded ids not present' do
      skill1 = create(:skill, name: 'Skill1')
      skill2 = create(:skill, name: 'Skill2')

      expect(described_class.names_that_exclude(%w[09990 555543])) .to contain_exactly(
        skill1.name,
        skill2.name
      )
    end

    it 'returns nothing if there are no skills' do
      expect(described_class.names_that_exclude('1')).to be_empty
    end
  end
end
