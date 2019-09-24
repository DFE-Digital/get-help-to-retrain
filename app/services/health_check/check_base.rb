module HealthCheck
  class CheckBase
    attr_reader :output

    def name
      raise NotImplementedError
    end

    def status
      raise NotImplementedError
    end

    def time
      Time.now.iso8601
    end

    def detail
      {
        status: status,
        time: time
      }.tap do |details|
        details[:metricValue] = value if respond_to?(:value)
        details[:metricUnit] = unit if respond_to?(:unit)
        details[:output] = output if output.present?
      end
    end
  end
end
