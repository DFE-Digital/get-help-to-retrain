require 'rails_helper'

RSpec.describe SkillsBuilder do
  describe '#build' do
    it 'does not set user_session if no skills params available' do
      job_profile = create(:job_profile, skills: [create(:skill)])
      builder = described_class.new(
        skills_params: nil,
        job_profile: job_profile,
        user_session: {}
      )

      builder.build
      expect(builder.user_session[:job_profile_skills]).to be_empty
    end

    it 'sets user_session to correct skills format if skills params available' do
      job_profile = create(:job_profile, skills: [create(:skill)])
      builder = described_class.new(
        skills_params: %w[1 2],
        job_profile: job_profile,
        user_session: {}
      )

      builder.build
      expect(builder.user_session).to eq(job_profile_skills: { job_profile.id.to_s => [1, 2] })
    end

    it 'ignores empty skill param ids when setting user_session' do
      job_profile = create(:job_profile, skills: [create(:skill)])
      builder = described_class.new(
        skills_params: ['1', ''],
        job_profile: job_profile,
        user_session: {}
      )

      builder.build
      expect(builder.user_session).to eq(job_profile_skills: { job_profile.id.to_s => [1] })
    end

    it 'overrides existing user session with new skill param ids' do
      job_profile = create(:job_profile, skills: [create(:skill)])
      builder = described_class.new(
        skills_params: ['1', '', '5', '6'],
        job_profile: job_profile,
        user_session: { job_profile_skills: { job_profile.id.to_s => [3, 4] } }
      )

      builder.build
      expect(builder.user_session).to eq(job_profile_skills: { job_profile.id.to_s => [1, 5, 6] })
    end

    it 'handles existing user session with new skill param ids if another job profile present' do
      job_profile1 = create(:job_profile, skills: [create(:skill)])
      job_profile2 = create(:job_profile, skills: [create(:skill)])
      builder = described_class.new(
        skills_params: ['1', '', '5', '6'],
        job_profile: job_profile2,
        user_session: { job_profile_skills: { job_profile1.id.to_s => [3, 4] } }
      )

      builder.build
      expect(builder.user_session).to eq(
        job_profile_skills: {
          job_profile1.id.to_s => [3, 4],
          job_profile2.id.to_s => [1, 5, 6]
        }
      )
    end

    it 'updates existing user session with skill param ids if another job profile present' do
      job_profile1 = create(:job_profile, skills: [create(:skill)])
      job_profile2 = create(:job_profile, skills: [create(:skill)])
      builder = described_class.new(
        skills_params: ['1', '', '5', '6'],
        job_profile: job_profile2,
        user_session: {
          job_profile_skills: {
            job_profile1.id.to_s => [3, 4],
            job_profile2.id.to_s => [3]
          }
        }
      )

      builder.build
      expect(builder.user_session).to eq(
        job_profile_skills: {
          job_profile1.id.to_s => [3, 4],
          job_profile2.id.to_s => [1, 5, 6]
        }
      )
    end
  end

  describe '#skill_ids' do
    it 'returns all job profile skill ids if no user_session' do
      skill1 = create(:skill)
      skill2 = create(:skill)
      job_profile = create(:job_profile, skills: [skill1, skill2])

      builder = described_class.new(
        skills_params: nil,
        job_profile: job_profile,
        user_session: {}
      )

      builder.build
      expect(builder.skill_ids).to eq([skill1.id, skill2.id])
    end

    it 'returns skill ids if user_session populated' do
      skill1 = create(:skill)
      skill2 = create(:skill)
      job_profile = create(:job_profile, skills: [skill1, skill2])
      builder = described_class.new(
        skills_params: nil,
        job_profile: job_profile,
        user_session: { job_profile_skills: { job_profile.id.to_s => [skill1.id] } }
      )

      builder.build
      expect(builder.skill_ids).to eq([skill1.id])
    end

    it 'returns updated skill ids if skills_params populated' do
      skill1 = create(:skill)
      skill2 = create(:skill)
      job_profile = create(:job_profile, skills: [skill1, skill2])

      builder = described_class.new(
        skills_params: ['1', '', '2'],
        job_profile: job_profile,
        user_session: { job_profile_skills: { job_profile.id.to_s => [3, 4] } }
      )

      builder.build
      expect(builder.skill_ids).to eq([1, 2])
    end

    it 'returns correct skill ids for given job profile if multiple job profiles saved' do
      skill1 = create(:skill)
      skill2 = create(:skill)
      skill3 = create(:skill)
      job_profile1 = create(:job_profile, skills: [skill1, skill2])
      job_profile2 = create(:job_profile, skills: [skill1, skill3])

      builder = described_class.new(
        skills_params: [skill3.id.to_s, ''],
        job_profile: job_profile2,
        user_session: {
          job_profile_skills: {
            job_profile1.id.to_s => [skill1.id],
            job_profile2.id.to_s => [skill1.id]
          }
        }
      )

      builder.build
      expect(builder.skill_ids).to eq([skill3.id])
    end
  end

  describe 'validation' do
    it 'is invalid if no skills selected' do
      job_profile = create(:job_profile, skills: [create(:skill)])
      builder = described_class.new(
        skills_params: [''],
        job_profile: job_profile,
        user_session: {}
      )

      expect(builder).not_to be_valid
    end

    it 'is valid if skills selected' do
      job_profile = create(:job_profile, skills: [create(:skill)])
      builder = described_class.new(
        skills_params: ['1', '', '4'],
        job_profile: job_profile,
        user_session: {}
      )

      expect(builder).to be_valid
    end
  end
end
