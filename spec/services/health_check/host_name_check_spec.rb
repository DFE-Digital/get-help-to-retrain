require 'rails_helper'

RSpec.describe HealthCheck::HostNameCheck do
  subject(:check) { described_class.new }

  describe '#status' do
    context 'with no host name configured' do
      it 'returns fail' do
        Rails.configuration.host_name = nil
        expect(check.status).to eq :fail
      end
    end

    context 'with host name configured' do
      it 'returns pass' do
        Rails.configuration.host_name = 'foo_host'
        expect(check.status).to eq :pass
      end
    end
  end

  describe '#detail' do
    let(:timestamp) { Time.httpdate('Fri, 20 Sep 2019 13:03:20 GMT') }

    before do
      Rails.configuration.host_name = 'foo_host'
      allow(Time).to receive(:now).and_return(timestamp)
    end

    it 'returns hash' do
      expect(check.detail).to eq(
        metricUnit: 'String',
        metricValue: 'foo_host',
        status: :pass,
        time: '2019-09-20T13:03:20Z'
      )
    end
  end
end
