require 'rails_helper'

RSpec.describe UserJourneyHelper do
  before do
    helper.singleton_class.class_eval do
      def user_session
        UserSession.new(session)
      end
    end
  end

  describe '#postcode_step' do
    context 'when POSTCODE is on the session' do
      it 'returns nil' do
        user_session = UserSession.new(session)
        user_session.postcode = 'NW6 11F'

        expect(helper.postcode_step).to be_nil
      end
    end

    context 'when POSTCODE is not on the session' do
      it 'returns location_eligibility_path' do
        expect(helper.postcode_step).to eq location_eligibility_path
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
