require 'rails_helper'

RSpec.describe HealthCheck::CoursesCheck do
  subject(:check) { described_class.new }

  describe '#status' do
    context 'with no courses populated' do
      it 'returns fail' do
        expect(check.status).to eq :fail
      end
    end

    context 'with at least one course populated' do
      before do
        create(:course)
      end

      it 'returns pass' do
        expect(check.status).to eq :pass
      end
    end
  end

  describe '#detail' do
    let(:timestamp) { Time.httpdate('Fri, 20 Sep 2019 13:03:20 GMT') }

    before do
      allow(Course).to receive(:count).and_return(100)
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
