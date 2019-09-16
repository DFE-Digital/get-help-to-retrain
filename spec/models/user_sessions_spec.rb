require 'rails_helper'

RSpec.describe UserSession do
  subject(:user_session) { described_class.new(session) }

  let(:session) { create_fake_session({}) }

  before do
    disable_feature! :skills_builder_v2
    session[:version] = 1
  end

  describe '.merge_sessions' do
    it 'merges old data into new session for selected keys' do
      old_session = {
        'postcode' => 'NW118QE',
        'session_id' => 2
      }
      new_session = { 'session_id' => 1 }
      described_class.merge_sessions(new_session: new_session, previous_session_data: old_session)

      expect(new_session).to eq('postcode' => 'NW118QE', 'session_id' => 1)
    end

    it 'overrides set values in current session with old ones' do
      old_session = {
        'version' => 5,
        'job_profile_skills' => { '11' => [2, 3, 5] }
      }
      new_session = {
        'version' => 2,
        'job_profile_skills' => { '11' => [4] }
      }
      described_class.merge_sessions(new_session: new_session, previous_session_data: old_session)

      expect(new_session).to eq('version' => 5, 'job_profile_skills' => { '11' => [2, 3, 5] })
    end
  end

  describe '#version' do
    it 'sets version on new session' do
      user_session = described_class.new(create_fake_session(session, versioned: false))

      expect(user_session.version).to eq(1)
    end

    it 'retains correct version on existing session' do
      session = { version: 1 }
      user_session = described_class.new(create_fake_session(session, versioned: false))

      expect(user_session.version).to eq(1)
    end

    it 'retains session when version correct on existing session' do
      session = {
        version: 1,
        job_profile_skills: { '11' => [2, 3, 5] }
      }
      user_session = described_class.new(create_fake_session(session, versioned: false))

      expect(user_session.job_profile_skills).to eq('11' => [2, 3, 5])
    end

    it 'resets version when existing version does not equal current version' do
      session = { version: 0 }
      user_session = described_class.new(create_fake_session(session, versioned: false))

      expect(user_session.version).to eq(1)
    end

    it 'reset session when existing session has wrong version' do
      session = {
        version: 0,
        job_profile_skills: { '11' => [2, 3, 5] }
      }
      user_session = described_class.new(create_fake_session(session, versioned: false))

      expect(user_session.job_profile_skills).to be_empty
    end

    it 'reset session when existing session does not have a version' do
      session = { job_profile_skills: { '11' => [2, 3, 5] } }
      user_session = described_class.new(create_fake_session(session, versioned: false))

      expect(user_session.job_profile_skills).to be_empty
    end

    context 'when skills builder v2 is enabled' do
      it 'reset session when existing session has wrong version' do
        enable_feature! :skills_builder_v2
        session = {
          version: 1,
          job_profile_skills: { '11' => [2, 3, 5] }
        }
        user_session = described_class.new(create_fake_session(session, versioned: false))

        expect(user_session.job_profile_skills).to be_empty
      end
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

  describe '#registration_triggered_from' do
    it 'sets registration_triggered_path if path is part of app' do
      referer = 'http://myapp/skills?job_profile_id=hitman'
      user_session.registration_triggered_from(referer)

      expect(user_session.registration_triggered_path).to eq('/skills?job_profile_id=hitman')
    end

    it 'does not set registration_triggered_path if path is not part of app' do
      referer = 'http://not-my-app/dodgy-path'
      user_session.registration_triggered_from(referer)

      expect(user_session.registration_triggered_path).to be_nil
    end

    it 'does not set registration_triggered_path if its part of urls to ignore' do
      referer = 'http://myapp/save-my-results'
      user_session.registration_triggered_from(referer, ['/save-my-results'])

      expect(user_session.registration_triggered_path).to be_nil
    end

    it 'does not set registration_triggered_path if its part of urls to ignore and theres a query' do
      referer = 'http://myapp/save-your-results?some-query'
      user_session.registration_triggered_from(referer, ['/save-your-results'])

      expect(user_session.registration_triggered_path).to be_nil
    end
  end

  describe '#current_job_id' do
    it 'returns current_job_id value if set' do
      user_session.current_job_id = 1

      expect(user_session.current_job_id).to eq(1)
    end

    it 'returns nil if no postcode set' do
      expect(user_session.current_job_id).to be_nil
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
  end

  describe '#track_page' do
    it 'does store the tracked page in the session under visited_pages key' do
      user_session.track_page('some_page')

      expect(session[:visited_pages]).to contain_exactly('some_page')
    end

    it 'does store duplicates in the session' do
      2.times do
        user_session.track_page('some_page')
      end

      expect(session[:visited_pages]).to contain_exactly('some_page')
    end
  end

  describe '#current_job?' do
    context 'when current_job_id key is on the session' do
      let(:session) {
        create_fake_session(
          current_job_id: 12,
          job_profile_skills: {
            '11' => [2, 3, 5],
            '12' => [2, 9, 4]
          }
        )
      }

      it 'returns true when current_job_id key is on the session' do
        expect(user_session.current_job?).to be true
      end
    end

    context 'when current_job_id key is not on the session' do
      let(:session) {
        create_fake_session(
          job_profile_skills: {
            '11' => [2, 3, 5],
            '12' => [2, 9, 4]
          }
        )
      }

      it 'returns false when current_job_id key is not on the session' do
        expect(user_session.current_job?).to be false
      end
    end
  end

  describe '#page_visited?' do
    it 'returns true if the page has alreaady been persisted on the session' do
      user_session.track_page('some_page')

      expect(user_session.page_visited?('some_page')).to be true
    end

    it 'returns false if the page is not yet persisted on the session' do
      expect(user_session.page_visited?('some_page')).to be false
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

  describe '#job_profiles_cap_reached?' do
    let(:session) {
      create_fake_session(
        job_profile_skills: {
          '11' => [2, 3, 5],
          '12' => [2, 9, 4],
          '8' => [3, 5],
          '4' => [9],
          '6' => []
        }
      )
    }

    it 'returns false if the number profile ids with at least one skill is less than 5' do
      expect(user_session.job_profiles_cap_reached?).to be false
    end

    it 'returns true if the number profile ids with at least one skill is greater or equal than 5' do
      session[:job_profile_skills]['6'] = [5, 1]

      expect(user_session.job_profiles_cap_reached?).to be true
    end
  end

  describe '#unblock_all_sections?' do
    it 'returns false if there are no sessions for all pages' do
      expect(user_session).not_to be_unblock_all_sections
    end

    it 'returns false if only skills matcher unblocked' do
      user_session.track_page('skills_matcher_index')

      expect(user_session).not_to be_unblock_all_sections
    end

    it 'returns true if skills matcher and training hub unblocked' do
      user_session.track_page('skills_matcher_index')
      user_session.track_page('training_hub')

      expect(user_session).to be_unblock_all_sections
    end

    it 'returns true if skills matcher and next steps unblocked' do
      user_session.track_page('skills_matcher_index')
      user_session.track_page('next_steps')

      expect(user_session).to be_unblock_all_sections
    end

    it 'returns false if training hub and next steps unblocked' do
      user_session.track_page('training_hub')
      user_session.track_page('next_steps')

      expect(user_session).not_to be_unblock_all_sections
    end
  end

  describe '#skill_ids' do
    context 'when there is a current_job_id on the session and we are using Skills Builder v1' do
      let(:session) {
        create_fake_session(
          current_job_id: 11,
          job_profile_skills: {
            '11' => [2, 3, 5],
            '12' => [2, 9, 4]
          }
        )
      }

      it 'returns the skill ids on the session that belong to job profile id: 11' do
        expect(user_session.skill_ids).to contain_exactly(2, 3, 5)
      end
    end

    context 'when there is no current_job_id on the session' do
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
  end

  describe '#job_profile_ids' do
    context 'when there is a current_job_id on the session and we are using Skills Builder v1' do
      let(:session) {
        create_fake_session(
          current_job_id: 12,
          job_profile_skills: {
            '11' => [2, 3, 5],
            '12' => [2, 9, 4]
          }
        )
      }

      it 'returns just the current job profile id on the session' do
        expect(user_session.job_profile_ids).to contain_exactly(12)
      end
    end

    context 'when there is no current_job_id on the session' do
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
