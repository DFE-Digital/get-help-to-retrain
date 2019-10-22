module HealthCheck
  class EnvironmentCheck < CheckBase
    CACHE_EXPIRY = 60.seconds

    def name
      'environment'
    end

    def value
      Rails.configuration.environment_name
    end

    def unit
      'String'
    end

    def status
      value.present? ? :pass : :fail
    end
  end
end
