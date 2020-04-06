module HealthCheck
  class NotifyCheck < CheckBase
    CACHE_EXPIRY = 42.seconds

    def enabled?
      Rails.configuration.admin_mode == false
    end

    def name
      'api:notifications.service.gov.uk'
    end

    def value
      @value ||= fetch_value
    end

    def unit
      'UUID'
    end

    def status
      value.present? ? :pass : :warn
    end

    private

    def fetch_value
      NotifyService.new.health_check
    rescue StandardError => e
      @output = "Notify API error: #{e.message}"
      nil
    end
  end
end
