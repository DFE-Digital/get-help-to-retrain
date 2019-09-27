if Rails.configuration.sentry_dsn.present?
  Raven.configure do |config|
    config.dsn = Rails.configuration.sentry_dsn
    config.sanitize_fields = Rails.configuration.filter_parameters.map(&:to_s)
    config.release = Rails.configuration.git_commit
    config.current_environment = Rails.configuration.environment_name
    config.server_name = Rails.configuration.host_name
  end
end
