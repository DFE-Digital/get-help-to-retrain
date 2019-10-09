require 'rails_helper'

RSpec.describe HealthCheck::FindAJobCheck do
  subject(:check) { described_class.new }

  let(:ping_response) { { 'ping' => 'ok' } }

  describe '#status' do
    context 'with failed Find a Job API call' do
      before do
        stub_request(:get, /ping/)
          .to_return(status: 500)
      end

      it 'returns warn' do
        expect(check.status).to eq :warn
      end
    end

    context 'with successful Find a Job API call' do
      before do
        stub_request(:get, /ping/)
          .to_return(body: ping_response.to_json)
      end

      it 'returns pass' do
        expect(check.status).to eq :pass
      end
    end
  end

  describe '#detail' do
    let(:timestamp) { Time.httpdate('Fri, 20 Sep 2019 13:03:20 GMT') }

    before do
      stub_request(:get, /ping/)
        .to_return(body: ping_response.to_json)
      allow(Time).to receive(:now).and_return(timestamp)
    end

    it 'returns hash' do
      expect(check.detail).to eq(
        metricUnit: 'JSON',
        metricValue: ping_response,
        status: :pass,
        time: '2019-09-20T13:03:20Z'
      )
    end
  end
end
