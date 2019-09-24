require 'rails_helper'

RSpec.describe TrackingService do
  subject(:service) { described_class }

  describe '.track_event' do
    context 'without an instrumentation key' do
      before do
        service.key = nil
      end

      it 'does not track events' do
        expect(service.track_event('foo')).to eq false
      end
    end

    context 'with a valid instrumentation key' do
      before do
        service.key = 'VALID'
      end

      it 'tracks event without additional properties' do
        allow(service.channel).to receive(:write).and_return(true)
        expect(service.track_event('foo')).to eq true
      end

      it 'tracks event with additional properties' do
        allow(service.channel).to receive(:write).and_return(true)
        expect(service.track_event('foo', bar: 'baz')).to eq true
      end
    end
  end
end
