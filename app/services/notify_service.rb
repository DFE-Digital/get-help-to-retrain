require 'notifications/client'

class NotifyService
  NotifyAPIError = Class.new(StandardError)
  CONFIRMATION_TEMPLATE_ID = 'b6b33372-f57b-4603-b8d2-8f66b4cebf24'.freeze
  LINK_TO_RESULTS_TEMPLATE_ID = '7d186e79-31d6-4f11-b5d9-5f1f83b0d159'.freeze

  def initialize(api_key: Rails.configuration.notify_api_key)
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
