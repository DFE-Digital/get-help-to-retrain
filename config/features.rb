Flipflop.configure do
  # Strategies will be used in the order listed here.

  strategy :query_string
  strategy :active_record

  group :phase_3 do
    feature :search_jobs_form
    feature :start_button
  end

  # Other strategies:
  #
  # strategy :sequel
  # strategy :redis
  #
  # strategy :query_string
  # strategy :session
  #
  # strategy :my_strategy do |feature|
  #   # ... your custom code here; return true/false/nil.
  # end

  # Declare your features, e.g:
  #
  # feature :world_domination,
  #   default: true,
  #   description: "Take over the world."
end
