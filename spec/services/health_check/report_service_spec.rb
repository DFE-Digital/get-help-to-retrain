require 'rails_helper'

RSpec.describe HealthCheck::ReportService do
  subject(:service) { described_class.new }

  describe '#report' do
    let(:report) { service.report }

    before do
      allow(HealthCheck::CheckBase).to receive(:descendants).and_return([])
    end

    it 'includes overall status' do
      expect(report[:status]).to eq :pass
    end

    it 'includes version' do
      Rails.configuration.git_commit = '123456abcdef'
      expect(report[:version]).to eq '123456abcdef'
    end

    it 'includes details of each service' do
      expect(report[:details]).to be_a Hash
    end

    it 'includes description' do
      expect(report[:description]).to eq 'Get help to retrain service health check'
    end
  end

  describe '#status' do
    before do
      allow(HealthCheck::CheckBase).to receive(:descendants).and_return(
        [
          HealthCheck::JobProfilesCheck,
          HealthCheck::SessionsCheck
        ]
      )
    end

    context 'with all services passing' do
      before do
        create :job_profile
        create :session
      end

      it 'returns pass status' do
        expect(service.status).to eq(:pass)
      end
    end

    context 'with one or more service warnings' do
      before do
        create :job_profile
      end

      it 'returns warn status' do
        expect(service.status).to eq(:warn)
      end
    end

    context 'with one or more service errors' do
      it 'returns fail status' do
        expect(service.status).to eq(:fail)
      end
    end
  end

  describe '#details' do
    let(:timestamp) { Time.httpdate('Fri, 20 Sep 2019 13:03:20 GMT') }

    before do
      allow(HealthCheck::CheckBase).to receive(:descendants).and_return(
        [
          HealthCheck::CoursesCheck
        ]
      )
      allow(Time).to receive(:now).and_return(timestamp)
    end

    it 'returns details of each service' do
      expect(service.details).to eq(
        'database:courses' => [
          {
            metricUnit: 'Integer',
            metricValue: 0,
            status: :fail,
            time: '2019-09-20T13:03:20Z'
          }
        ]
      )
    end
  end
end
