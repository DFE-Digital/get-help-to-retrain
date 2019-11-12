require 'rails_helper'

RSpec.describe QuestionHelper do
  let(:user_session) { UserSession.new(session) }

  before do
    helper.singleton_class.class_eval do
      def user_session
        UserSession.new(session)
      end
    end
  end

  describe '#action_plan_or_questions_path' do
    it 'returns training path when training question not answered' do
      expect(helper.action_plan_or_questions_path).to eq(training_questions_path)
    end

    it 'returns job_hunting when only training question answered' do
      user_session.training = ['english_skills']

      expect(helper.action_plan_or_questions_path).to eq(job_hunting_questions)
    end

    it 'returns training when only job_hunting question answered' do
      user_session.job_hunting = ['cv']

      expect(helper.action_plan_or_questions_path).to eq(training_questions_path)
    end

    it 'returns action plan path when both questions answered' do
      user_session.training = ['english_skills']
      user_session.job_hunting = ['cv']

      expect(helper.action_plan_or_questions_path).to eq(action_plan_path)
    end
  end

  describe '#job_hunting_questions' do
    it 'returns nil when job hunting question answered' do
      user_session.job_hunting = ['cv']

      expect(helper.job_hunting_questions).to be_nil
    end

    it 'returns path when job hunting question not answered' do
      expect(helper.job_hunting_questions).to eq(job_hunting_questions_path)
    end
  end

  describe '#training_questions' do
    it 'returns nil when training question answered' do
      user_session.training = ['english_skills']

      expect(helper.training_questions).to be_nil
    end

    it 'returns path when training question not answered' do
      expect(helper.training_questions).to eq(training_questions_path)
    end
  end
end
