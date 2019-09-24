require 'rails_helper'

RSpec.describe HealthCheck::JobProfilesCheck do
  subject(:check) { described_class.new }

  describe '#status' do
    context 'with no job profiles populated' do
      it 'returns fail' do
        expect(check.status).to eq :fail
      end
    end

    context 'with at least one job profile populated' do
      before do
        create(:job_profile)
      end

      it 'returns pass' do
        expect(check.status).to eq :pass
      end
    end
  end

  describe '#detail' do
    let(:timestamp) { Time.httpdate('Fri, 20 Sep 2019 13:03:20 GMT') }

    before do
      allow(JobProfile).to receive(:count).and_return(850)
      allow(Time).to receive(:now).and_return(timestamp)
    end

    it 'returns hash' do
      expect(check.detail).to eq(
        metricUnit: 'Integer',
        metricValue: 850,
        status: :pass,
        time: '2019-09-20T13:03:20Z'
      )
    end
  end
end
