require 'rails_helper'

RSpec.describe SkillsMatcher do
  describe '#match' do
    it 'returns no jobs if no session skills selected' do
      session = create_fake_session({})
      create(:job_profile, skills: [create(:skill)])
      matcher = described_class.new(UserSession.new(session))

      expect(matcher.match).to be_empty
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

    it 'scopes job profiles to user session job profile if job profile current id exists for Skills Builder v1' do
      skill1 = create(:skill)
      skill2 = create(:skill)
      skill3 = create(:skill)
      skill4 = create(:skill)
      job_profile1 = create(:job_profile, skills: [skill1, skill3])
      create(:job_profile, skills: [skill2])
      job_profile2 = create(:job_profile, skills: [skill1, skill2, skill3, skill4])
      job_profile3 = create(:job_profile, skills: [skill1, skill3])
      session = create_fake_session(
        current_job_id: job_profile1.id,
        job_profile_ids: [job_profile2.id, job_profile1.id],
        job_profile_skills: {
          job_profile2.id.to_s => [skill1.id, skill2.id],
          job_profile1.id.to_s => [skill1.id, skill3.id, skill4.id]
        }
      )
      matcher = described_class.new(UserSession.new(session))

      expect(matcher.match).to eq([job_profile2, job_profile3])
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
      puts matcher.send(:build_query).to_sql
      puts ActiveRecord::Base.connection.execute('select datname, datcollate from pg_database;').first

      expect(matcher.match).to eq(
        [
          job_profile4,
          job_profile3,
          job_profile5,
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

    it 'returns job profiles matched to multiple skills across multiple jobs profiles scoped to profile for Skills Builder v1' do
      skill1 = create(:skill)
      skill2 = create(:skill)
      skill3 = create(:skill)
      job_profile1 = create(:job_profile, skills: [skill1, skill2])
      job_profile2 = create(:job_profile, skills: [skill1])
      job_profile3 = create(:job_profile, skills: [skill1, skill2])
      create(:job_profile, skills: [skill2])
      session = create_fake_session(
        current_job_id: job_profile2.id,
        job_profile_ids: [job_profile1.id, job_profile2.id],
        job_profile_skills: {
          job_profile1.id.to_s => [skill2.id],
          job_profile2.id.to_s => [skill1.id, skill3.id]
        }
      )
      matcher = described_class.new(UserSession.new(session))

      expect(matcher.job_profile_scores).to eq(
        job_profile1.id => 50.0,
        job_profile3.id => 50.0
      )
    end
  end
end
