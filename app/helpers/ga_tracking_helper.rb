module GaTrackingHelper
  def track_selections(event_key, selected: {}, unselected: {})
    return unless selected.present? || unselected.present?

    event_props = [selected, unselected].map { |option|
      build_event_props(label: option[:label], values: option[:values])
    }.flatten

    track_events(
      event_key,
      event_props
    )
  end

  private

  def build_event_props(label:, values:)
    values.map do |value|
      {
        label: label,
        value: value
      }
    end
  end
end
