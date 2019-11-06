module HealthCheck
  class FindAJobCheck < CheckBase
    CACHE_EXPIRY = 50.seconds

    def name
      'api:findajob.dwp.gov.uk'
    end

    def value
      @value ||= FindAJobService.new.health_check
    rescue FindAJobService::APIError => e
      @output = "Find A Job API error: #{e.message}"
      ''
    end

    def unit
      'JSON'
    end

    def status
      value.present? ? :pass : :warn
    end
  end
end
