module HealthCheck
  class FindAJobCheck < CheckBase
    def name
      'api:findajob.dwp.gov.uk'
    end

    def value
      @value ||= FindAJobService.new.health_check
    rescue FindAJobService::ResponseError => e
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
