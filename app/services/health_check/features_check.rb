module HealthCheck
  class FeaturesCheck < CheckBase
    def name
      'api:split.io'
    end

    def value
      @value ||= Flipflop.health_check?
    rescue StandardError => e
      @output = "SplitIO error: #{e.inspect}"
      false
    end

    def unit
      'Boolean'
    end

    def status
      value ? :pass : :fail
    end
  end
end