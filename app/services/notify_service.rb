require 'notifications/client'

class NotifyService
  NotifyAPIError = Class.new(StandardError)

  def initialize(api_key: ENV['NOTIFY_API_KEY'])
    @api_key = api_key
  end

  def send_email(email_address:, template_id:, options: {})
    client.send_email(
      email_address: email_address,
      template_id: template_id,
      personalisation: options
    )
  rescue Notifications::Client::RequestError, RuntimeError => e
    Rails.logger.error("Notify API error: #{e.message}")
    raise NotifyAPIError
  end

  private

  def client
    @client ||= Notifications::Client.new(api_key)
  end

  def api_key
    raise 'NOTIFY_API_KEY is not set' unless @api_key.present?

    @api_key
  end
end
