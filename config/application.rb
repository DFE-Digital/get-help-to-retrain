require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
# require 'action_cable/engine'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GetHelpToRetrain
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults '6.0'
    Rails.autoloaders.main.ignore("#{Rails.root}/app/admin")

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.exceptions_app = routes

    config.i18n.default_locale = :'en-GB'

    # Explicitly load middleware classes
    Dir.glob(Rails.root.join('app', 'middleware', '*.rb')) { |f| require f }
    config.middleware.insert_before Rails::Rack::Logger, StatusReport

    config.admin_mode = ENV['ADMIN_MODE'] == 'true'
    config.google_analytics_tracking_id = ENV['GOOGLE_ANALYTICS_TRACKING_ID']
    config.notify_api_key = ENV['NOTIFY_API_KEY']
    config.find_a_job_api_id = ENV['FIND_A_JOB_API_ID']
    config.find_a_job_api_key = ENV['FIND_A_JOB_API_KEY']
    config.git_commit = ENV['GIT_SHA']
    config.sentry_dsn = ENV['SENTRY_DSN']
    config.environment_name = ENV['ENVIRONMENT_NAME'] || 'development'
    config.host_name = Socket.gethostname
    config.bing_spell_check_api_key = ENV['BING_SPELL_CHECK_API_KEY']
    config.bing_spell_check_api_endpoint = ENV['BING_SPELL_CHECK_API_ENDPOINT']
    config.azure_client_id = ENV['AZURE_CLIENT_ID']
    config.azure_client_secret = ENV['AZURE_CLIENT_SECRET']
    config.azure_scopes = ENV['AZURE_SCOPES']
    config.azure_tenant_id = ENV['AZURE_TENANT_ID']
    config.azure_management_role_id = ENV['AZURE_MANAGEMENT_ROLE_ID']
    config.azure_readwrite_role_id = ENV['AZURE_READWRITE_ROLE_ID']
    config.azure_read_role_id = ENV['AZURE_READ_ROLE_ID']
  end
end
