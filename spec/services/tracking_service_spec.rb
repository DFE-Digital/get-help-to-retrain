require 'rails_helper'

RSpec.describe TrackingService do
  subject(:service) { described_class.new(ga_tracking_id: ga_tracking_id) }

  let(:ga_tracking_id) { 'test' }

  let(:ga_response) {
    'GIF89a\x01\x00\x01\x00\x80\xFF\x00\xFF\xFF\xFF\x00\;'
  }

  let(:anonymized_client_id) {
    SecureRandom.uuid
  }

  let(:event_payload) {
    {
      tid: ga_tracking_id,
      cid: anonymized_client_id,
      t: 'event',
      v: 1,
      ec: 'event_category',
      el: 'Event Label',
      ea: 'Event action'
    }
  }

  def fake_ga_request_with(payload, debug: false)
    api_endpoint = debug ? TrackingService::DEBUG_API_ENDPOINT : TrackingService::API_ENDPOINT

    stub_request(:post, api_endpoint)
      .with(body: URI.encode_www_form(payload))
      .to_return(body: ga_response, status: 200)
  end

  describe '.track_event' do
    context 'without a ga_tracking ID' do
      subject(:service) { described_class.new }

      it 'does not make a call to GA' do
        net_http = instance_spy(Net::HTTP)

        service.track_event(key: 'key', label: 'label', value: 'value')

        expect(net_http).not_to have_received(:start)
      end
    end

    context 'without event props' do
      it 'does not make a call to GA' do
        net_http = instance_spy(Net::HTTP)

        service.track_event(key: nil, label: nil, value: nil)

        expect(net_http).not_to have_received(:start)
      end
    end

    context 'with a valid ga_tracking ID' do
      before do
        fake_ga_request_with(event_payload)

        allow(SecureRandom).to receive(:uuid).and_return(anonymized_client_id)
      end

      it 'returns the correct response' do
        expect(
          service.track_event(
            key: :event_category,
            label: 'Event Label',
            value: 'Event action'
          )
        ).to eq ga_response
      end
    end

    context 'with a valid ga_tracking ID and debug mode on' do
      subject(:service) { described_class.new(ga_tracking_id: ga_tracking_id, debug: true) }

      let(:ga_response) {
        {
          "hitParsingResult": [
            {
              "valid": false,
              "hit": "GET /debug/collect?tid=fake\u0026v=1 HTTP/1.1",
              "parserMessage": [
                {
                  "messageType": 'ERROR',
                  "description": 'The value provided for parameter \'tid\' is invalid.',
                  "parameter": 'tid'
                },
                {
                  "messageType": 'ERROR',
                  "description": 'Tracking Id is a required field for this hit.',
                  "parameter": 'tid'
                }
              ]
            }
          ]
        }.to_json
      }

      before do
        fake_ga_request_with(event_payload, debug: true)

        allow(SecureRandom).to receive(:uuid).and_return(anonymized_client_id)
      end

      it 'returns an actual JSON object' do
        expect(
          service.track_event(
            key: :event_category,
            label: 'Event Label',
            value: 'Event action'
          )
        ).to eq ga_response
      end
    end

    context 'when the service does experience an error' do
      it 'raises a TrackingServiceError' do
        allow(Net::HTTP).to receive(:start).and_raise(RuntimeError)

        expect {
          service.track_event(
            key: :event_category,
            label: 'Event Label',
            value: 'Event action'
          )
        }.to raise_exception(described_class::TrackingServiceError)
      end
    end
  end
end
