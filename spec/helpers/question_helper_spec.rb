require 'rails_helper'

RSpec.describe QuestionHelper do
  before do
    helper.singleton_class.class_eval do
      def user_session
        UserSession.new(session)
      end
    end
  end

  describe '#job_hunting_questions' do
    it 'returns nil when job hunting question answered' do
      user_session = UserSession.new(session)
      user_session.job_hunting = ['cv']

      expect(helper.job_hunting_questions).to be_nil
    end

    it 'returns path when job hunting question not answered' do
      expect(helper.job_hunting_questions).to eq(job_hunting_questions_path)
    end
  end

  describe '#training_questions' do
    it 'returns nil when training question answered' do
      user_session = UserSession.new(session)
      user_session.training = ['english_skills']

      expect(helper.training_questions).to be_nil
    end

    it 'returns path when training question not answered' do
      expect(helper.training_questions).to eq(training_questions_path)
    end
  end
end
