require 'rails_helper'

RSpec.describe HealthCheck::FeaturesCheck do
  subject(:check) { described_class.new }

  describe '#status' do
    context 'with failed split.io API call' do
      before do
        disable_feature!(:health_check)
      end

      it 'returns fail' do
        expect(check.status).to eq :fail
      end
    end

    context 'with successful split.io API call' do
      before do
        enable_feature!(:health_check)
      end

      it 'returns pass' do
        expect(check.status).to eq :pass
      end
    end
  end

  describe '#detail' do
    let(:timestamp) { Time.httpdate('Fri, 20 Sep 2019 13:03:20 GMT') }

    before do
      enable_feature!(:health_check)
      allow(Time).to receive(:now).and_return(timestamp)
    end

    it 'returns hash' do
      expect(check.detail).to eq(
        metricUnit: 'Boolean',
        metricValue: true,
        status: :pass,
        time: '2019-09-20T13:03:20Z'
      )
    end
  end
end
