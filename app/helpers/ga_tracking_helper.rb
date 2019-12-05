module GaTrackingHelper
  def track_selections(selected: {}, unselected: {})
    return unless selected.present? || unselected.present?

    event_props = [selected, unselected].map { |option|
      build_event_props(key: option[:key], label: option[:label], values: option[:values])
    }.flatten

    track_events(
      event_props
    )
  end

  private

  def build_event_props(key:, label:, values:)
    values.map do |value|
      {
        key: key,
        label: label,
        value: value
      }
    end
  end
end
