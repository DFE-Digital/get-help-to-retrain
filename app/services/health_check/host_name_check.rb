module HealthCheck
  class HostNameCheck < CheckBase
    CACHE_EXPIRY = 57.seconds

    def name
      'hostname'
    end

    def value
      Rails.configuration.host_name
    end

    def unit
      'String'
    end

    def status
      value.present? ? :pass : :fail
    end
  end
end
