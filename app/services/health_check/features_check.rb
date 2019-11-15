module HealthCheck
  class FeaturesCheck < CheckBase
    CACHE_EXPIRY = 55.seconds

    def name
      'api:split.io'
    end

    def value
      @value ||= fetch_value
    end

    def unit
      'Boolean'
    end

    def status
      value ? :pass : :fail
    end

    private

    def fetch_value
      Flipflop.health_check?
    rescue StandardError => e
      @output = "SplitIO error: #{e.inspect}"
      false
    end
  end
end
