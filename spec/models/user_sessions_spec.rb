require 'rails_helper'

RSpec.describe UserSession do
  subject(:user_session) { described_class.new(session) }

  let(:session) { HashWithIndifferentAccess.new }

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
      session[:job_profile_skills] = { '1' => [2, 3] }

      expect(user_session.job_profile_skills?).to be true
    end

    it 'returns false if the session does not contain job profile skills' do
      expect(user_session.job_profile_skills?).to be false
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
        {
          current_job_id: 11,
          job_profile_skills: {
            '11' => [2, 3, 5],
            '12' => [2, 9, 4]
          }
        }
      }

      it 'returns the skill ids on the session that belong to job profile id: 11' do
        enable_feature! :skills_builder

        expect(user_session.skill_ids).to contain_exactly(2, 3, 5)
      end
    end

    context 'when there is no current_job_id on the session' do
      let(:session) {
        {
          job_profile_skills: {
            '11' => [2, 3, 5],
            '12' => [2, 9, 4]
          }
        }
      }

      it 'returns the all skill ids on the session' do
        expect(user_session.skill_ids).to contain_exactly(2, 3, 5, 9, 4)
      end
    end
  end

  describe '#job_profile_ids' do
    context 'when there is a current_job_id on the session and we are using Skills Builder v1' do
      let(:session) {
        {
          current_job_id: 12,
          job_profile_skills: {
            '11' => [2, 3, 5],
            '12' => [2, 9, 4]
          }
        }
      }

      it 'returns just the current job profile id on the session' do
        enable_feature! :skills_builder

        expect(user_session.job_profile_ids).to contain_exactly(12)
      end
    end

    context 'when there is no current_job_id on the session' do
      let(:session) {
        {
          job_profile_skills: {
            '11' => [2, 3, 5],
            '12' => [2, 9, 4]
          }
        }
      }

      it 'returns all the job profile ids on the session' do
        enable_feature! :skills_builder

        expect(user_session.job_profile_ids).to contain_exactly(11, 12)
      end
    end
  end

  describe '#store_at' do
    it 'stores the given value at the given key isnide the session' do
      user_session.store_at(key: :some_key, value: 'some_value')

      expect(session[:some_key]).to eq 'some_value'
    end
  end

  describe '#current_job?' do
    context 'when current_job_id key is on the session' do
      let(:session) {
        {
          current_job_id: 12,
          job_profile_skills: {
            '11' => [2, 3, 5],
            '12' => [2, 9, 4]
          }
        }
      }

      it 'returns true when current_job_id key is on the session' do
        expect(user_session.current_job?).to be true
      end
    end

    context 'when current_job_id key is not on the session' do
      let(:session) {
        {
          job_profile_skills: {
            '11' => [2, 3, 5],
            '12' => [2, 9, 4]
          }
        }
      }

      it 'returns false when current_job_id key is not on the session' do
        expect(user_session.current_job?).to be false
      end
    end
  end

  describe '#skill_ids_for_profile' do
    let(:session) {
      {
        job_profile_skills: {
          '11' => [2, 3, 5],
          '12' => [2, 9, 4]
        }
      }
    }

    it 'returns the skills for a given job profile id' do
      expect(user_session.skill_ids_for_profile(11)).to contain_exactly(2, 3, 5)
    end
  end
end
