module HealthCheck
  class JobProfilesCheck < CheckBase
    CACHE_EXPIRY = 45.seconds

    def name
      'database:jobProfiles'
    end

    def value
      @value ||= fetch_value
    end

    def unit
      'Integer'
    end

    def status
      value.zero? ? :fail : :pass
    end

    private

    def fetch_value
      JobProfile.count
    rescue StandardError => e
      @output = "Database error: #{e.inspect}"

      0
    end
  end
end
