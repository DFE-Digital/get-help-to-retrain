require 'rails_helper'

RSpec.describe HealthCheck::EnvironmentCheck do
  subject(:check) { described_class.new }

  describe '#status' do
    context 'with no environment name configured' do
      it 'returns fail' do
        Rails.configuration.environment_name = nil
        expect(check.status).to eq :fail
      end
    end

    context 'with environment name configured' do
      it 'returns pass' do
        Rails.configuration.environment_name = 'unicorn'
        expect(check.status).to eq :pass
      end
    end
  end

  describe '#detail' do
    let(:timestamp) { Time.httpdate('Fri, 20 Sep 2019 13:03:20 GMT') }

    before do
      Rails.configuration.environment_name = 'unicorn'
      allow(Time).to receive(:now).and_return(timestamp)
    end

    it 'returns hash' do
      expect(check.detail).to eq(
        metricUnit: 'String',
        metricValue: 'unicorn',
        status: :pass,
        time: '2019-09-20T13:03:20Z'
      )
    end
  end
end
