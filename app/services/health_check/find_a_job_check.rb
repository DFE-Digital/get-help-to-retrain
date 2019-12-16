module HealthCheck
  class FindAJobCheck < CheckBase
    CACHE_EXPIRY = 50.seconds

    def enabled?
      Rails.configuration.admin_mode == false
    end

    def name
      'api:findajob.dwp.gov.uk'
    end

    def value
      @value ||= fetch_value
    end

    def unit
      'JSON'
    end

    def status
      value.present? ? :pass : :warn
    end

    private

    def fetch_value
      FindAJobService.new.health_check
    rescue FindAJobService::APIError => e
      @output = "Find A Job API error: #{e.message}"
      ''
    end
  end
end
