Rails.application.configure do
  if (app_insights_key = config.app_insights_instrumentation_key) && app_insights_key.present?
    config.middleware.use(ApplicationInsights::Rack::TrackRequest, app_insights_key)
    if config.app_insights_javascript
      config.middleware.use(ApplicationInsights::Rack::InjectJavaScriptTracking, app_insights_key)
    end

    # setup unhandled exception handler
    ApplicationInsights::UnhandledException.collect(app_insights_key)
  end
end
