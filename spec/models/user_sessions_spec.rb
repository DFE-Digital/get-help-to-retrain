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
end
