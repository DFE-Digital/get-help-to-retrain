require 'rails_helper'

RSpec.describe UserSession do
  subject(:user_session) { described_class.new(session) }

  let(:session) { create_fake_session({}) }

  describe '.merge_sessions' do
    it 'merges old data into new session for selected keys' do
      old_session = {
        'postcode' => 'NW118QE',
        'distance' => '30',
        'target_job_id' => 100,
        'session_id' => 2,
        'training' => ['english_skills'],
        'job_hunting' => ['cv'],
        'skills_matcher_sort' => 'growth'
      }
      new_session = { 'session_id' => 1 }
      described_class.merge_sessions(new_session: new_session, previous_session_data: old_session)

      expect(new_session).to eq(
        'postcode' => 'NW118QE',
        'distance' => '30',
        'target_job_id' => 100,
        'session_id' => 1,
        'training' => ['english_skills'],
        'job_hunting' => ['cv'],
        'skills_matcher_sort' => 'growth'
      )
    end

    it 'overrides set values in current session with old ones' do
      old_session = {
        'job_profile_skills' => { '11' => [2, 3, 5] }
      }
      new_session = {
        'job_profile_skills' => { '11' => [4] }
      }
      described_class.merge_sessions(new_session: new_session, previous_session_data: old_session)

      expect(new_session).to eq('job_profile_skills' => { '11' => [2, 3, 5] })
    end
  end

  describe '#postcode' do
    it 'returns postcode value if set' do
      user_session.postcode = 'NW118QE'

      expect(user_session.postcode).to eq('NW118QE')
    end

    it 'returns nil if no postcode set' do
      expect(user_session.postcode).to be_nil
    end
  end

  describe '#distance' do
    it 'returns distance value if set' do
      user_session.distance = '20'

      expect(user_session.distance).to eq('20')
    end

    it 'returns nil if no distance set' do
      expect(user_session.distance).to be_nil
    end
  end

  describe '#skills_matcher_sort' do
    it 'returns order if set' do
      user_session.skills_matcher_sort = 'growth'

      expect(user_session.skills_matcher_sort).to eq('growth')
    end

    it 'returns nil if no order set' do
      expect(user_session.skills_matcher_sort).to be_nil
    end
  end

  describe '#target_job_id' do
    it 'returns targetted job id if set' do
      user_session.target_job_id = 100

      expect(user_session.target_job_id).to eq(100)
    end

    it 'returns nil if no targetted job id set' do
      expect(user_session.target_job_id).to be_nil
    end
  end

  describe '#training' do
    it 'returns training value if set' do
      user_session.training = ['english_skills']

      expect(user_session.training).to contain_exactly('english_skills')
    end

    it 'returns an empty array if no training set' do
      expect(user_session.training).to be_nil
    end
  end

  describe '#it_training' do
    it 'returns IT training value if set' do
      user_session.it_training = ['computer_skills']

      expect(user_session.it_training).to contain_exactly('computer_skills')
    end

    it 'returns an empty array if no IT training set' do
      expect(user_session.it_training).to be_nil
    end
  end

  describe '#job_hunting' do
    it 'returns job_hunting value if set' do
      user_session.job_hunting = %w[cv cover_letter]

      expect(user_session.job_hunting).to contain_exactly('cv', 'cover_letter')
    end

    it 'returns an empty array if no job_hunting set' do
      expect(user_session.job_hunting).to be_nil
    end
  end

  describe '#cookies' do
    it 'returns cookies if set' do
      user_session.cookies = true

      expect(user_session.cookies).to eq(true)
    end

    it 'returns nil if no cookies set' do
      expect(user_session.cookies).to be_nil
    end
  end

  describe '#registered' do
    it 'returns registered value if set' do
      user_session.registered = true

      expect(user_session).to be_registered
    end

    it 'returns nil if no registered set' do
      expect(user_session).not_to be_registered
    end
  end

  describe '#registration_triggered_path' do
    it 'returns registration_triggered_path value if set' do
      session[:registration_triggered_path] = 'some-path'

      expect(user_session.registration_triggered_path).to eq('some-path')
    end

    it 'returns nil if no registration_triggered_path set' do
      expect(user_session.registration_triggered_path).to be_nil
    end
  end

  describe '#registration_triggered_path' do
    it 'sets registration_triggered_path' do
      referer = '/skills?job_profile_id=hitman'
      user_session.registration_triggered_path = referer

      expect(user_session.registration_triggered_path).to eq('/skills?job_profile_id=hitman')
    end

    it 'does not overwrite registration_triggered_path if there is no referer' do
      session[:registration_triggered_path] = 'some-path'
      user_session.registration_triggered_path = nil

      expect(user_session.registration_triggered_path).to eq('some-path')
    end
  end

  describe '#job_profile_skills' do
    it 'returns job_profile_skills value if set' do
      session[:job_profile_skills] = { '1' => [2, 3] }

      expect(user_session.job_profile_skills).to eq('1' => [2, 3])
    end

    it 'returns empty hash if no job_profile_skills set' do
      expect(user_session.job_profile_skills).to eq({})
    end
  end

  describe '#set_skills_ids_for_profile' do
    it 'stores the given skills for a job profile id' do
      user_session.set_skills_ids_for_profile(1, [2, 3])

      expect(user_session.job_profile_skills).to eq('1' => [2, 3])
    end

    it 'stores the given job profile id in job profile ids' do
      user_session.set_skills_ids_for_profile(1, [2, 3])

      expect(user_session.job_profile_ids).to eq([1])
    end
  end

  describe '#remove_job_profile' do
    it 'removes a job profile from job profile skills' do
      user_session.set_skills_ids_for_profile(1, [2, 3])
      user_session.remove_job_profile(1)

      expect(user_session.job_profile_skills).to eq({})
    end

    it 'removes a job profile from job profile ids' do
      user_session.set_skills_ids_for_profile(1, [2, 3])
      user_session.remove_job_profile(1)

      expect(user_session.job_profile_ids).to eq([])
    end

    it 'does nothing if a job profile does not exist in job profile skills' do
      user_session.remove_job_profile(1)

      expect(user_session.job_profile_skills).to eq({})
    end

    it 'does nothing if job profiles does not exist in job profile ids' do
      user_session.remove_job_profile(1)

      expect(user_session.job_profile_ids).to eq([])
    end
  end

  describe '#job_profile_skills?' do
    it 'returns true if the session already contains job profile skills' do
      session[:job_profile_ids] = [1]

      expect(user_session.job_profile_skills?).to be true
    end

    it 'returns false if the session does not contain job profile skills' do
      expect(user_session.job_profile_skills?).to be false
    end
  end

  describe '#target_job?' do
    it 'returns true if the session already contains target_job_id' do
      user_session.target_job_id = 1

      expect(user_session.target_job?).to be true
    end

    it 'returns false if the session already contains target_job_id' do
      expect(user_session.target_job?).to be false
    end
  end

  describe '#job_profiles_cap_reached?' do
    let(:session) {
      create_fake_session(
        job_profile_ids: [11, 12, 8, 4]
      )
    }

    it 'returns false if the number profile ids with at least one skill is less than 5' do
      expect(user_session.job_profiles_cap_reached?).to be false
    end

    it 'returns true if the number profile ids with at least one skill is greater or equal than 5' do
      session[:job_profile_ids] << 6

      expect(user_session.job_profiles_cap_reached?).to be true
    end
  end

  describe '#skill_ids' do
    let(:session) {
      create_fake_session(
        job_profile_skills: {
          '11' => [2, 3, 5],
          '12' => [2, 9, 4]
        }
      )
    }

    it 'returns the all skill ids on the session' do
      expect(user_session.skill_ids).to contain_exactly(2, 3, 5, 9, 4)
    end
  end

  describe '#job_profile_ids' do
    let(:session) {
      create_fake_session(
        job_profile_ids: [11, 12],
        job_profile_skills: {
          '11' => [2, 3, 5],
          '12' => [2, 9, 4]
        }
      )
    }

    it 'returns all the job profile ids on the session' do
      expect(user_session.job_profile_ids).to contain_exactly(11, 12)
    end

    it 'does not add duplicates do job profile ids' do
      user_session.set_skills_ids_for_profile(11, [2, 3])
      user_session.set_skills_ids_for_profile(11, [2, 5])
      user_session.set_skills_ids_for_profile(11, [2, 3, 5])
      expect(user_session.job_profile_ids).to contain_exactly(11, 12)
    end
  end

  describe '#skill_ids_for_profile' do
    let(:session) {
      create_fake_session(
        job_profile_skills: {
          '11' => [2, 3, 5],
          '12' => [2, 9, 4]
        }
      )
    }

    it 'returns the skills for a given job profile id' do
      expect(user_session.skill_ids_for_profile(11)).to contain_exactly(2, 3, 5)
    end
  end
end
