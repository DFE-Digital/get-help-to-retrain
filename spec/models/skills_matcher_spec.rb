require 'rails_helper'

RSpec.describe SkillsMatcher do
  describe '#match' do
    it 'returns no jobs if no session skills selected' do
      session = create_fake_session({})
      create(:job_profile, skills: [create(:skill)])
      matcher = described_class.new(UserSession.new(session))

      expect(matcher.match).to be_empty
    end

    it 'limits maximum number of job matches' do
      skill = create(:skill)
      job_profile1 = create(:job_profile, skills: [skill])
      create_list(:job_profile, 11, skills: [skill])
      session = create_fake_session(
        job_profile_ids: [job_profile1.id],
        job_profile_skills: {
          job_profile1.id.to_s => [skill.id]
        }
      )
      matcher = described_class.new(UserSession.new(session), limit: 10)

      expect(matcher.match.length).to eq 10
    end

    it 'returns multiple jobs matching skill selected ignoring job profiles in the session' do
      skill = create(:skill)
      job_profile1 = create(:job_profile, skills: [skill])
      job_profile2 = create(:job_profile, skills: [skill])
      job_profile3 = create(:job_profile, skills: [skill])
      session = create_fake_session(
        job_profile_ids: [job_profile1.id],
        job_profile_skills: {
          job_profile1.id.to_s => [skill.id]
        }
      )
      matcher = described_class.new(UserSession.new(session))

      expect(matcher.match).to contain_exactly(job_profile2, job_profile3)
    end

    it 'returns multiple jobs matching different skills within profiles selected' do
      skill1 = create(:skill)
      skill2 = create(:skill)
      skill3 = create(:skill)
      job_profile1 = create(:job_profile, skills: [skill1, skill3])
      create(:job_profile, skills: [skill2])
      job_profile2 = create(:job_profile, skills: [skill2, skill3])
      job_profile3 = create(:job_profile, skills: [skill1, skill3])
      session = create_fake_session(
        job_profile_ids: [job_profile1.id],
        job_profile_skills: {
          job_profile1.id.to_s => [skill1.id, skill3.id]
        }
      )
      matcher = described_class.new(UserSession.new(session))

      expect(matcher.match).to contain_exactly(job_profile2, job_profile3)
    end

    it 'returns multiple jobs matching different skills across profiles selected' do
      skill1 = create(:skill)
      skill2 = create(:skill)
      skill3 = create(:skill)
      job_profile1 = create(:job_profile, skills: [skill1])
      create(:job_profile, skills: [skill2])
      job_profile2 = create(:job_profile, skills: [skill3])
      job_profile3 = create(:job_profile, skills: [skill3])
      job_profile4 = create(:job_profile, skills: [skill1])
      session = create_fake_session(
        job_profile_ids: [job_profile1.id, job_profile2.id],
        job_profile_skills: {
          job_profile1.id.to_s => [skill1.id],
          job_profile2.id.to_s => [skill3.id]
        }
      )
      matcher = described_class.new(UserSession.new(session))

      expect(matcher.match).to contain_exactly(job_profile3, job_profile4)
    end

    it 'orders jobs by number of skills matched' do
      skill1 = create(:skill)
      skill2 = create(:skill)
      skill3 = create(:skill)
      job_profile1 = create(:job_profile, skills: [skill1, skill3])
      job_profile2 = create(:job_profile, skills: [skill2])
      job_profile3 = create(:job_profile, skills: [skill1, skill2, skill3])
      job_profile4 = create(:job_profile, skills: [skill1, skill2, skill3])
      job_profile5 = create(:job_profile, skills: [skill1, skill3])
      session = create_fake_session(
        job_profile_ids: [job_profile3.id, job_profile1.id],
        job_profile_skills: {
          job_profile3.id.to_s => [skill1.id, skill2.id],
          job_profile1.id.to_s => [skill1.id, skill3.id]
        }
      )
      matcher = described_class.new(UserSession.new(session))

      expect(matcher.match).to eq([job_profile4, job_profile5, job_profile2])
    end

    it 'arranges job profiles in alphabetical order as well as matching skills order' do
      skill1 = create(:skill)
      skill2 = create(:skill)
      skill3 = create(:skill)
      job_profile1 = create(:job_profile, skills: [skill1, skill2, skill3])
      job_profile2 = create(:job_profile, name: 'Researcher', skills: [skill2])
      job_profile3 = create(:job_profile, name: 'Beekeeper', skills: [skill1, skill2, skill3])
      job_profile4 = create(:job_profile, name: 'Admin', skills: [skill1, skill2, skill3])
      job_profile5 = create(:job_profile, name: 'Boat builder', skills: [skill3])
      session = create_fake_session(
        job_profile_ids: [job_profile1.id],
        job_profile_skills: {
          job_profile1.id.to_s => [skill1.id, skill2.id, skill3.id]
        }
      )

      matcher = described_class.new(UserSession.new(session))
      expect(matcher.match).to eq(
        [
          job_profile4,
          job_profile3,
          job_profile5,
          job_profile2
        ]
      )
    end

    it 'arranges job profiles in matching skills order as well as job growth type order' do
      skill = create(:skill)
      job_profile1 = create(:job_profile, skills: [skill])
      job_profile2 = create(:job_profile, skills: [skill], growth: -5)
      job_profile3 = create(:job_profile, skills: [skill], growth: 60)
      session = create_fake_session(
        job_profile_ids: [job_profile1.id],
        job_profile_skills: {
          job_profile1.id.to_s => [skill.id]
        }
      )

      matcher = described_class.new(UserSession.new(session))
      expect(matcher.match).to eq(
        [
          job_profile3,
          job_profile2
        ]
      )
    end

    it 'arranges job profiles in job growth type order as well as matching skills order' do
      skill1 = create(:skill)
      skill2 = create(:skill)
      skill3 = create(:skill)
      job_profile1 = create(:job_profile, skills: [skill1, skill2, skill3])
      job_profile2 = create(:job_profile, growth: 60, name: 'Researcher', skills: [skill2])
      job_profile3 = create(:job_profile, growth: -5, name: 'Beekeeper', skills: [skill1, skill2, skill3])
      job_profile4 = create(:job_profile, growth: -5, name: 'Admin', skills: [skill1, skill2, skill3])
      job_profile5 = create(:job_profile, growth: 60, name: 'Boat builder', skills: [skill3])
      session = create_fake_session(
        job_profile_ids: [job_profile1.id],
        job_profile_skills: {
          job_profile1.id.to_s => [skill1.id, skill2.id, skill3.id]
        }
      )

      matcher = described_class.new(UserSession.new(session), order: :growth)
      expect(matcher.match).to eq(
        [
          job_profile5,
          job_profile2,
          job_profile4,
          job_profile3
        ]
      )
    end

    it 'arranges job profiles in job growth type order and profiles with job growth nil go at the end' do
      skill = create(:skill)
      job_profile1 = create(:job_profile, skills: [skill])
      job_profile2 = create(:job_profile, skills: [skill], growth: -5)
      job_profile3 = create(:job_profile, skills: [skill], growth: nil)
      job_profile4 = create(:job_profile, skills: [skill], growth: 50)
      session = create_fake_session(
        job_profile_ids: [job_profile1.id],
        job_profile_skills: {
          job_profile1.id.to_s => [skill.id]
        }
      )

      matcher = described_class.new(UserSession.new(session))
      expect(matcher.match).to eq(
        [
          job_profile4,
          job_profile2,
          job_profile3
        ]
      )
    end


    it 'arranges job profiles in matching skills order, then job growth type order, then alphabetical order' do
      skill1 = create(:skill)
      skill2 = create(:skill)
      skill3 = create(:skill)
      job_profile1 = create(:job_profile, skills: [skill1, skill2, skill3])
      job_profile2 = create(:job_profile, name: 'Researcher', skills: [skill2], growth: 59)
      job_profile3 = create(:job_profile, name: 'Beekeeper', skills: [skill1, skill2, skill3], growth: 45)
      job_profile4 = create(:job_profile, name: 'Office Admin', skills: [skill1, skill2, skill3], growth: -5)
      job_profile6 = create(:job_profile, name: 'Admin', skills: [skill1, skill2, skill3], growth: -6)
      job_profile5 = create(:job_profile, name: 'Boat builder', skills: [skill3], growth: 52)
      session = create_fake_session(
        job_profile_ids: [job_profile1.id],
        job_profile_skills: {
          job_profile1.id.to_s => [skill1.id, skill2.id, skill3.id]
        }
      )

      matcher = described_class.new(UserSession.new(session))
      expect(matcher.match).to eq(
        [
          job_profile3,
          job_profile6,
          job_profile4,
          job_profile5,
          job_profile2
        ]
      )
    end

    it 'arranges job profiles in matching skills, job growth type and skills rarity order' do
      skill1 = create(:skill, rarity: nil)
      skill2 = create(:skill, rarity: 3)
      skill3 = create(:skill, rarity: 2)
      skill4 = create(:skill, rarity: 1)
      job_profile1 = create(:job_profile)
      job_profile2 = create(:job_profile, skills: [skill1, skill2], growth: 1.6)
      job_profile3 = create(:job_profile, skills: [skill1, skill3], growth: 4.2)
      job_profile4 = create(:job_profile, skills: [skill1, skill4], growth: 2)

      session = create_fake_session(
        job_profile_ids: [job_profile1.id],
        job_profile_skills: {
          job_profile1.id.to_s => [skill1.id, skill2.id, skill3.id, skill4.id]
        }
      )

      matcher = described_class.new(UserSession.new(session))
      expect(matcher.match).to eq(
        [
          job_profile4,
          job_profile3,
          job_profile2
        ]
      )
    end

    it 'arranges job profiles in job growth_type, matching skills and skills rarity order' do
      skill1 = create(:skill, rarity: nil)
      skill2 = create(:skill, rarity: 3)
      skill3 = create(:skill, rarity: 2)
      skill4 = create(:skill, rarity: 1)
      job_profile1 = create(:job_profile)
      job_profile2 = create(:job_profile, growth: 0, skills: [skill1, skill2])
      job_profile3 = create(:job_profile, growth: 0, skills: [skill1, skill3])
      job_profile4 = create(:job_profile, growth: 0, skills: [skill1, skill4])

      session = create_fake_session(
        job_profile_ids: [job_profile1.id],
        job_profile_skills: {
          job_profile1.id.to_s => [skill1.id, skill2.id, skill3.id, skill4.id]
        }
      )

      matcher = described_class.new(UserSession.new(session), order: :growth)
      expect(matcher.match).to eq(
        [
          job_profile4,
          job_profile3,
          job_profile2
        ]
      )
    end

    it 'ignores unrecommended jobs' do
      skill = create(:skill)
      job_profile1 = create(:job_profile, skills: [skill])
      create(:job_profile, :excluded, skills: [skill])
      job_profile2 = create(:job_profile, skills: [skill])
      session = create_fake_session(
        job_profile_ids: [job_profile1.id],
        job_profile_skills: {
          job_profile1.id.to_s => [skill.id]
        }
      )
      matcher = described_class.new(UserSession.new(session))

      expect(matcher.match).to contain_exactly(job_profile2)
    end
  end

  describe '#job_profile_scores' do
    it 'returns job profiles mapped to a percentage of skills match to total user skills' do
      skill = create(:skill)
      job_profile1 = create(:job_profile, skills: [skill])
      job_profile2 = create(:job_profile, skills: [skill])
      job_profile3 = create(:job_profile, skills: [skill])
      session = create_fake_session(
        job_profile_ids: [job_profile1.id],
        job_profile_skills: {
          job_profile1.id.to_s => [skill.id]
        }
      )
      matcher = described_class.new(UserSession.new(session))

      expect(matcher.job_profile_scores).to eq(
        job_profile2.id => 100.0,
        job_profile3.id => 100.0
      )
    end

    it 'returns job profiles matched to multiple skills with the correct percentage score' do
      skill1 = create(:skill)
      skill2 = create(:skill)
      job_profile1 = create(:job_profile, skills: [skill1, skill2])
      job_profile2 = create(:job_profile, skills: [skill1])
      job_profile3 = create(:job_profile, skills: [skill1, skill2])
      session = create_fake_session(
        job_profile_ids: [job_profile1.id],
        job_profile_skills: {
          job_profile1.id.to_s => [skill1.id, skill2.id]
        }
      )
      matcher = described_class.new(UserSession.new(session))

      expect(matcher.job_profile_scores).to eq(
        job_profile2.id => 50.0,
        job_profile3.id => 100.0
      )
    end

    it 'returns job profiles matched to multiple skills across multiple jobs profiles with the correct score' do
      skill1 = create(:skill)
      skill2 = create(:skill)
      job_profile1 = create(:job_profile, skills: [skill1, skill2])
      job_profile2 = create(:job_profile, skills: [skill1])
      job_profile3 = create(:job_profile, skills: [skill1, skill2])
      job_profile4 = create(:job_profile, skills: [skill2])
      session = create_fake_session(
        job_profile_ids: [job_profile1.id, job_profile2.id],
        job_profile_skills: {
          job_profile1.id.to_s => [skill2.id],
          job_profile2.id.to_s => [skill1.id]
        }
      )

      matcher = described_class.new(UserSession.new(session))

      expect(matcher.job_profile_scores).to eq(
        job_profile4.id => 50.0,
        job_profile3.id => 100.0
      )
    end
  end
end
