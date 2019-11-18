module HealthCheck
  class CoursesCheck < CheckBase
    CACHE_EXPIRY = 40.seconds

    def name
      'database:courses'
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
      @value ||= Course.count
    rescue StandardError => e
      @output = "Database error: #{e.inspect}"

      0
    end
  end
end
