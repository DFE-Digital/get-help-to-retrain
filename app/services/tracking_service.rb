class TrackingService
  def self.track_event(event_text, properties = {}, request_id)
    return false unless key.present?

    client.context.operation.id = request_id

    client.track_event(event_text, properties: properties)
  end

  def self.key
    @key ||= Rails.configuration.app_insights_instrumentation_key
  end

  def self.key=(key)
    @key = key
    @sender = nil
    @queue = nil
    @channel = nil
    @client = nil
  end

  def self.sender
    @sender ||= ApplicationInsights::Channel::AsynchronousSender.new
  end

  def self.queue
    @queue ||= ApplicationInsights::Channel::AsynchronousQueue.new(sender)
  end

  def self.channel
    @channel ||= ApplicationInsights::Channel::TelemetryChannel.new(nil, queue)
  end

  def self.client
    @client ||= ApplicationInsights::TelemetryClient.new(key, channel).tap do |tc|
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
  end
end
