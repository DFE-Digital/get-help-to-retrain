require 'rails_helper'

RSpec.describe SkillsBuilder do
  describe '#build' do
    it 'does not set user_session if no skills params available' do
      builder = described_class.new(
        skills_params: nil,
        job_profile_skills: [create(:skill)],
        user_session: {}
      )
      builder.build

      expect(builder.user_session).to be_empty
    end

    it 'sets user_session to correct skills format if skills params available' do
      builder = described_class.new(
        skills_params: %w[1 2],
        job_profile_skills: [create(:skill)],
        user_session: {}
      )
      builder.build

      expect(builder.user_session).to eq(skill_ids: [1, 2])
    end

    it 'ignores empty skill param ids when setting user_ession' do
      builder = described_class.new(
        skills_params: ['1', ''],
        job_profile_skills: [create(:skill)],
        user_session: {}
      )
      builder.build

      expect(builder.user_session).to eq(skill_ids: [1])
    end

    it 'overrides existing user session with new skill param ids' do
      builder = described_class.new(
        skills_params: ['1', '', '5', '6'],
        job_profile_skills: [create(:skill)],
        user_session: { skill_ids: [3, 4] }
      )
      builder.build

      expect(builder.user_session).to eq(skill_ids: [1, 5, 6])
    end
  end

  describe '#skill_ids' do
    it 'returns all job profile skill ids if no user_session empty' do
      skill1 = create(:skill)
      skill2 = create(:skill)

      builder = described_class.new(
        skills_params: nil,
        job_profile_skills: [skill1, skill2],
        user_session: {}
      )

      builder.build
      expect(builder.skill_ids).to eq([skill1.id, skill2.id])
    end

    it 'returns skill ids if user_session populated' do
      skill1 = create(:skill)
      skill2 = create(:skill)

      builder = described_class.new(
        skills_params: nil,
        job_profile_skills: [skill1, skill2],
        user_session: { skill_ids: [3, 4] }
      )

      builder.build
      expect(builder.skill_ids).to eq([3, 4])
    end

    it 'returns updated skill ids if skills_params populated' do
      skill1 = create(:skill)
      skill2 = create(:skill)

      builder = described_class.new(
        skills_params: ['1', '', '2'],
        job_profile_skills: [skill1, skill2],
        user_session: { skill_ids: [3, 4] }
      )

      builder.build
      expect(builder.skill_ids).to eq([1, 2])
    end
  end

  describe 'validation' do
    it 'is invalid if no skills selected' do
      builder = described_class.new(
        skills_params: [''],
        job_profile_skills: [create(:skill)],
        user_session: {}
      )

      expect(builder).not_to be_valid
    end

    it 'is valid if skills selected' do
      builder = described_class.new(
        skills_params: ['1', '', '4'],
        job_profile_skills: [create(:skill)],
        user_session: {}
      )

      expect(builder).to be_valid
    end
  end
end
