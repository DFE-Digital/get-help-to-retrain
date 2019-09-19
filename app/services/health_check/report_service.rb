module HealthCheck
  class ReportService
    def report
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
      @checks ||= begin
        preload_check_classes
        CheckBase.descendants.map(&:new)
      end
    end

    def preload_check_classes
      # Zeitwerk handles eager loading all classes in production mode
      return if Rails.env.production?

      Dir.glob(Rails.root.join('app', 'services', 'health_check', '*.rb')) { |f| require f }
    end
  end
end
