require 'rails_helper'

RSpec.describe HealthCheck::SessionsCheck do
  subject(:check) { described_class.new }

  describe '#enabled' do
    it 'is true when not in admin mode' do
      expect(check).to be_enabled
    end

    it 'is false when in admin mode' do
      Rails.configuration.admin_mode = true
      expect(check).not_to be_enabled
    ensure
      Rails.configuration.admin_mode = false
    end
  end

  describe '#status' do
    context 'with no sessions populated' do
      it 'returns fail' do
        expect(check.status).to eq :fail
      end

      it 'returns fail if database not available' do
        allow(Session).to receive(:count).and_raise(PG::ConnectionBad)

        expect(check.status).to eq :fail
      end
    end

    context 'with at least one session populated' do
      before do
        create(:session)
      end

      it 'returns pass' do
        expect(check.status).to eq :pass
      end
    end
  end

  describe '#detail' do
    let(:timestamp) { Time.httpdate('Fri, 20 Sep 2019 13:03:20 GMT') }

    before do
      allow(Session).to receive(:count).and_return(100)
      allow(Time).to receive(:now).and_return(timestamp)
    end

    it 'returns hash' do
      expect(check.detail).to eq(
        metricUnit: 'Integer',
        metricValue: 100,
        status: :pass,
        time: '2019-09-20T13:03:20Z'
      )
    end
  end
end
