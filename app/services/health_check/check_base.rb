module HealthCheck
  class CheckBase
    attr_reader :output

    def enabled?
      true
    end

    def name
      raise NotImplementedError
    end

    def status
      raise NotImplementedError
    end

    def cached_status
      detail[:status]
    end

    def time
      Time.now.iso8601
    end

    def detail
      Rails.cache.fetch(self.class.name.humanize, expires_in: self.class::CACHE_EXPIRY) do
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
end
