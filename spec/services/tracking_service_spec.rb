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

  def fake_debug_request_with(payload)
    stub_request(:post, TrackingService::DEBUG_API_ENDPOINT)
      .with(body: URI.encode_www_form(payload))
      .to_return(body: ga_response, status: 200)
  end

  def fake_batch_request_with(bulk_payload)
    stub_request(:post, TrackingService::BATCH_API_ENDPOINT)
      .with(body: bulk_payload)
      .to_return(body: ga_response, status: 200)
  end

  describe '.track_events' do
    context 'without a ga_tracking ID' do
      subject(:service) { described_class.new }

      it 'does not make a call to GA' do
        net_http = instance_spy(Net::HTTP)

        service.track_events(props: [{ key: 'key', label: 'label', values: 'value' }])

        expect(net_http).not_to have_received(:start)
      end
    end

    context 'without event props' do
      let(:net_http) { instance_spy(Net::HTTP) }

      it 'raises TrackingServiceError' do
        expect {
          service.track_events(
            props: nil
          )
        }.to raise_error(described_class::TrackingServiceError, 'Event props must be present')
      end
    end

    context 'with a valid ga_tracking ID' do
      before do
        fake_batch_request_with(URI.encode_www_form(event_payload))

        allow(SecureRandom).to receive(:uuid).and_return(anonymized_client_id)
      end

      it 'returns the correct response' do
        expect(
          service.track_events(
            props: [
              {
                key: :event_category,
                label: 'Event Label',
                value: 'Event action'
              }
            ]
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
        fake_debug_request_with(event_payload)

        allow(SecureRandom).to receive(:uuid).and_return(anonymized_client_id)
      end

      it 'returns an actual JSON object' do
        expect(
          service.track_events(
            props: [
              {
                key: :event_category,
                label: 'Event Label',
                value: 'Event action'
              }
            ]
          )
        ).to eq ga_response
      end
    end

    context 'when the service does experience an error' do
      it 'raises a TrackingServiceError' do
        allow(Net::HTTP).to receive(:start).and_raise(RuntimeError)

        expect {
          service.track_events(
            props: [
              {
                key: :event_category,
                label: 'Event Label',
                values: 'Event action'
              }
            ]
          )
        }.to raise_exception(described_class::TrackingServiceError)
      end
    end

    context 'when batch size is exceeded' do
      let(:tracked_actions) { build_list(:skill, 21) }
      let(:props) {
        tracked_actions.map do |value|
          {
            label: 'Label',
            value: value,
            key: :event_category
          }
        end
      }

      it 'raises a TrackingServiceError' do
        expect {
          service.track_events(
            props: props
          )
        }.to raise_error(described_class::TrackingServiceError, 'Batch size cannot be over 20')
      end
    end

    context 'when sending multiple values to GA' do
      let(:bulk_payload) {
        [
          URI.encode_www_form(event_payload),
          URI.encode_www_form(other_event_payload)
        ].join("\n")
      }

      let(:other_event_payload) {
        {
          tid: ga_tracking_id,
          cid: anonymized_client_id,
          t: 'event',
          v: 1,
          ec: 'event_category',
          el: 'Event Label',
          ea: 'New event action'
        }
      }

      before do
        fake_batch_request_with(bulk_payload)

        allow(SecureRandom).to receive(:uuid).and_return(anonymized_client_id)
      end

      it 'sends them in batch' do
        expect(
          service.track_events(
            props: [
              {
                key: :event_category,
                label: 'Event Label',
                value: 'Event action'
              },
              {
                key: :event_category,
                label: 'Event Label',
                value: 'New event action'
              }
            ]
          )
        ).to eq ga_response
      end
    end
  end
end
