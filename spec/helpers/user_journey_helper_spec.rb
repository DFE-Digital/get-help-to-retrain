require 'rails_helper'

RSpec.describe UserJourneyHelper do
  before do
    helper.singleton_class.class_eval do
      def user_session
        UserSession.new(session)
      end
    end
  end

  describe '#pid_step' do
    context 'when PID is on the session' do
      it 'returns nil' do
        user_session = UserSession.new(session)
        user_session.pid = true

        expect(helper.pid_step).to be_nil
      end
    end

    context 'when PID is not the session' do
      it 'returns' do
        expect(helper.pid_step).to eq your_information_path
      end
    end
  end
end
