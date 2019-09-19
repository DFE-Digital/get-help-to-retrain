module HealthCheck
  class NotifyCheck < CheckBase
    def name
      'api:notifications.service.gov.uk'
    end

    def value
      @value ||= NotifyService.new.health_check.id
    rescue Notifications::Client::RequestError, RuntimeError => e
      @output = "Notify API error: #{e.message}"
      nil
    end

    def unit
      'GUID'
    end

    def status
      value.present? ? :pass : :warn
    end
  end
end
