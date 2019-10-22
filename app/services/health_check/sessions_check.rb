module HealthCheck
  class SessionsCheck < CheckBase
    CACHE_EXPIRY = 48.seconds

    def name
      'database:sessions'
    end

    def value
      @value ||= Session.count
    end

    def unit
      'Integer'
    end

    def status
      value.zero? ? :warn : :pass
    end
  end
end
