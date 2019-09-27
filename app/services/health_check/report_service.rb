unless Rails.env.production?
  # Explicitly load health check classes in development and test mode
  Dir.glob(Rails.root.join('app', 'services', 'health_check', '*.rb')) { |f| require f }
end

module HealthCheck
  class ReportService
    def report
      # Build JSON structure according to https://tools.ietf.org/html/draft-inadarei-api-health-check-01
      {
        status: status,
        version: Rails.configuration.git_commit,
        details: details,
        description: 'Get help to retrain service health check'
      }
    end

    def status
      return :pass if statuses.all?(:pass)
      return :fail if statuses.any?(:fail)

      :warn
    end

    def details
      checks.map { |check| [check.name, [check.detail]] }.to_h
    end

    private

    def statuses
      @statuses ||= checks.map(&:status)
    end

    def checks
      @checks ||= CheckBase.descendants.map(&:new)
    end
  end
end
