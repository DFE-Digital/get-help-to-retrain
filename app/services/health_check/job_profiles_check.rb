module HealthCheck
  class JobProfilesCheck < CheckBase
    CACHE_EXPIRY = 45.seconds

    def name
      'database:jobProfiles'
    end

    def value
      @value ||= JobProfile.count
    end

    def unit
      'Integer'
    end

    def status
      value.zero? ? :fail : :pass
    end
  end
end
