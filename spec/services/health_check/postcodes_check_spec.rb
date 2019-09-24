require 'rails_helper'

RSpec.describe HealthCheck::PostcodesCheck do
  subject(:check) { described_class.new }

  describe '#status' do
    context 'with failed geocoding API call' do
      before do
        allow(Geocoder).to receive(:coordinates).and_raise(Geocoder::ServiceUnavailable)
      end

      it 'returns warn' do
        expect(check.status).to eq :warn
      end
    end

    context 'with successful geocoding API call' do
      before do
        Geocoder::Lookup::Test.add_stub('B1 2JP', [{ 'coordinates' => [0.1, 0.2] }])
      end

      it 'returns pass' do
        expect(check.status).to eq :pass
      end
    end
  end

  describe '#detail' do
    let(:timestamp) { Time.httpdate('Fri, 20 Sep 2019 13:03:20 GMT') }

    before do
      Geocoder::Lookup::Test.add_stub('B1 2JP', [{ 'coordinates' => [0.1, 0.2] }])
      allow(Time).to receive(:now).and_return(timestamp)
    end

    it 'returns hash' do
      expect(check.detail).to eq(
        metricUnit: 'Array',
        metricValue: [0.1, 0.2],
        status: :pass,
        time: '2019-09-20T13:03:20Z'
      )
    end
  end
end
