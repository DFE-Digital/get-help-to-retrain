if Rails.configuration.sentry_dsn.present?
  Raven.configure do |config|
    config.dsn = Rails.configuration.sentry_dsn
    config.sanitize_fields = Rails.configuration.filter_parameters.map(&:to_s)
  end
end
