require 'rails_helper'

RSpec.describe 'Health check', type: :request do
  describe 'GET status#index' do
    let(:report) { { foo: 'bar' } }
    let(:health_check) { instance_double(HealthCheck::ReportService, report: report, status: status) }

    before do
      allow(HealthCheck::ReportService).to receive(:new).and_return(health_check)
    end

    it 'has correct content type' do
      get status_path
      expect(response.content_type).to eq 'application/health+json; charset=utf-8'
    end

    context 'when health check passes' do
      let(:status) { :pass }

      it 'has 200 response' do
        get status_path
        expect(response.status).to eq 200
      end
    end

    context 'when health check has warnings' do
      let(:status) { :warn }

      it 'has 207 response' do
        get status_path
        expect(response.status).to eq 207
      end
    end

    context 'when health check fails' do
      let(:status) { :fail }

      it 'has 503 response' do
        get status_path
        expect(response.status).to eq 503
      end
    end
  end
end
