module HealthCheck
  class SessionsCheck < CheckBase
    CACHE_EXPIRY = 48.seconds

    def enabled?
      Rails.configuration.admin_mode == false
    end

    def name
      'database:sessions'
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
      Session.count
    rescue StandardError => e
      @output = "Database error: #{e.inspect}"

      0
    end
  end
end
