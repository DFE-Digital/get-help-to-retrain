require 'rails_helper'

RSpec.describe GaTrackingHelper do
  describe '#track_selections' do
    before do
      helper.singleton_class.class_eval do
        def track_events(event_key, props = [])
          TrackingService.new.track_events(key: event_key, props: props)
        end
      end
    end

    let(:selected_options) {
      {
        label: 'Florist',
        values: ['must love plants', 'good sales skills']
      }
    }

    let(:unselected_options) {
      {
        label: 'Florist',
        values: ['attention to details']
      }
    }

    it 'sends the correct props to the TrackingService' do
      tracking_service = instance_spy(TrackingService)
      allow(TrackingService).to receive(:new).and_return(tracking_service)

      helper.track_selections(
        :skills_builder,
        selected: selected_options,
        unselected: unselected_options
      )

      expect(tracking_service).to have_received(:track_events).with(
        key: :skills_builder,
        props:
        [
          {
            label: 'Florist',
            value: 'must love plants'
          },
          {
            label: 'Florist',
            value: 'good sales skills'
          },
          {
            label: 'Florist',
            value: 'attention to details'
          }
        ]
      )
    end
  end
end
