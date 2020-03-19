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

  describe '#track_course_filter_for' do
    before do
      helper.singleton_class.class_eval do
        def track_event(event_key, event_value, scope)
          TrackingService.new.track_events(
            props: [
              {
                key: event_key,
                label: I18n.t(event_key, scope: scope),
                value: event_value
              }
            ]
          )
        end
      end
    end

    it 'sends the correct props to the TrackingService' do
      tracking_service = instance_spy(TrackingService)
      allow(TrackingService).to receive(:new).and_return(tracking_service)

      helper.track_course_filter_for(
        parameter: '1',
        value_mapping: [['Classroom based', '1']],
        label: 'events.course_type_filter'
      )

      expect(tracking_service).to have_received(:track_events).with(
        props:
        [
          {
            key: :filter_courses,
            label: 'Course type',
            value: 'Classroom based'
          }
        ]
      )
    end

    it 'does not send a tracking event if the parameter is empty' do
      tracking_service = instance_spy(TrackingService)
      allow(TrackingService).to receive(:new).and_return(tracking_service)

      helper.track_course_filter_for(
        parameter: nil,
        value_mapping: [['Classroom based', '1']],
        label: 'events.course_type_filter'
      )

      expect(tracking_service).not_to have_received(:track_events)
    end

    it 'does not send a tracking event if the parameter is set to all' do
      tracking_service = instance_spy(TrackingService)
      allow(TrackingService).to receive(:new).and_return(tracking_service)

      helper.track_course_filter_for(
        parameter: 'all',
        value_mapping: [%w[All all]],
        label: 'events.course_type_filter'
      )

      expect(tracking_service).not_to have_received(:track_events)
    end
  end
end
