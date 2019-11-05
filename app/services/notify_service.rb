require 'notifications/client'

class NotifyService
  NotifyAPIError = Class.new(StandardError)
  CONFIRMATION_TEMPLATE_ID = '02534375-5b5e-4da7-9884-009715421301'.freeze
  LINK_TO_RESULTS_TEMPLATE_ID = '7d186e79-31d6-4f11-b5d9-5f1f83b0d159'.freeze
  HEALTH_CHECK_TEMPLATE_ID = '73a33b7d-d9a2-4de1-8f54-848d22a5ea21'.freeze
  HEALTH_CHECK_EMAIL = 'simulate-delivered@notifications.service.gov.uk'.freeze

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

  def health_check
    client.send_email(
      email_address: HEALTH_CHECK_EMAIL,
      template_id: HEALTH_CHECK_TEMPLATE_ID
    ).id
  end

  private

  def client
    @client ||= Notifications::Client.new(api_key)
  rescue ArgumentError => e
    Rails.logger.error("Notify API error: #{e.message}")
    raise NotifyAPIError
  end

  def api_key
    raise 'NOTIFY_API_KEY is not set' unless @api_key.present?

    @api_key
  end
end
