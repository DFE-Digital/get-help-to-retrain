if Rails.env.production?
  Rails.application.configure do
    if (app_insights_key = ENV['APPINSIGHTS_INSTRUMENTATIONKEY']) && app_insights_key.present?
      config.middleware.use(ApplicationInsights::Rack::TrackRequest, app_insights_key)
      if ENV['APPINSIGHTS_JAVASCRIPT_ENABLED'] == 'true'
        config.middleware.use(ApplicationInsights::Rack::InjectJavaScriptTracking, app_insights_key)
      end

      # setup asynchronous sender and channel for use with telemetry client
      sender = ApplicationInsights::Channel::AsynchronousSender.new
      queue = ApplicationInsights::Channel::AsynchronousQueue.new(sender)
      channel = ApplicationInsights::Channel::TelemetryChannel.new(nil, queue)

      TELEMETRY_CLIENT = ApplicationInsights::TelemetryClient.new(app_insights_key, channel).tap do |tc|
        # flush telemetry if we have 10 or more telemetry items in our queue
        tc.channel.queue.max_queue_length = 10
        # send telemetry to the service in batches of 5
        tc.channel.sender.send_buffer_size = 5
        # the background worker thread will be active for 5 seconds before it shuts down. if
        # during this time items are picked up from the queue, the timer is reset.
        tc.channel.sender.send_time = 5
        # the background worker thread will poll the queue every 0.5 seconds for new items
        tc.channel.sender.send_interval = 0.5
      end

      # setup unhandled exception handler
      ApplicationInsights::UnhandledException.collect(app_insights_key)
    end
  end
end
