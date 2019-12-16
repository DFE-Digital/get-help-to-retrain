require 'rails_helper'

RSpec.describe HealthCheck::NotifyCheck do
  subject(:check) { described_class.new }

  let(:notify_service) { instance_double(NotifyService) }
  let(:id) { SecureRandom.uuid }

  before do
    allow(NotifyService).to receive(:new).and_return(notify_service)
  end

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
    context 'with failed notify API call' do
      before do
        allow(notify_service).to receive(:health_check).and_raise(RuntimeError)
      end

      it 'returns warn' do
        expect(check.status).to eq :warn
      end
    end

    context 'with successful notify API call' do
      before do
        allow(notify_service).to receive(:health_check).and_return(id)
      end

      it 'returns pass' do
        expect(check.status).to eq :pass
      end
    end
  end

  describe '#detail' do
    let(:timestamp) { Time.httpdate('Fri, 20 Sep 2019 13:03:20 GMT') }

    before do
      allow(notify_service).to receive(:health_check).and_return(id)
      allow(Time).to receive(:now).and_return(timestamp)
    end

    it 'returns hash' do
      expect(check.detail).to eq(
        metricUnit: 'UUID',
        metricValue: id,
        status: :pass,
        time: '2019-09-20T13:03:20Z'
      )
    end
  end
end
