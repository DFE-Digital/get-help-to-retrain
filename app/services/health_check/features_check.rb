module HealthCheck
  class FeaturesCheck < CheckBase
    def name
      'api:split.io'
    end

    def value
      @output = Flipflop::FeatureSet.current.features.map(&:as_json)
      @value ||= Flipflop.health_check?
    rescue StandardError => e
      @output = "SplitIO error: #{e.inspect}"
      nil
    end

    def unit
      'JSON'
    end

    def status
      value ? :pass : :fail
    end
  end
end
