require 'rails_helper'

RSpec.describe GaTrackingHelper do
  describe '#track_selections' do
    before do
      helper.singleton_class.class_eval do
        def track_events(props = [])
          TrackingService.new.track_events(props: props)
        end
      end
    end

    let(:selected_options) {
      {
        key: :skills_builder_ticked,
        label: 'Florist',
        values: ['must love plants', 'good sales skills']
      }
    }

    let(:unselected_options) {
      {
        key: :skills_builder_unticked,
        label: 'Florist',
        values: ['attention to details']
      }
    }

    it 'sends the correct props to the TrackingService' do
      tracking_service = instance_spy(TrackingService)
      allow(TrackingService).to receive(:new).and_return(tracking_service)

      helper.track_selections(
        selected: selected_options,
        unselected: unselected_options
      )

      expect(tracking_service).to have_received(:track_events).with(
        props:
        [
          {
            key: :skills_builder_ticked,
            label: 'Florist',
            value: 'must love plants'
          },
          {
            key: :skills_builder_ticked,
            label: 'Florist',
            value: 'good sales skills'
          },
          {
            key: :skills_builder_unticked,
            label: 'Florist',
            value: 'attention to details'
          }
        ]
      )
    end
  end
end
