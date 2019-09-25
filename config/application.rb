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

    config.app_insights_instrumentation_key = ENV['APPINSIGHTS_INSTRUMENTATIONKEY']
    config.app_insights_javascript = ENV['APPINSIGHTS_JAVASCRIPT_ENABLED'] == 'true'
    config.google_analytics_tracking_id = ENV['GOOGLE_ANALYTICS_TRACKING_ID']
    config.smart_survey_user_feedback_link = ENV['USER_FEEDBACK_SMART_SURVEY_LINK']
    config.notify_api_key = ENV['NOTIFY_API_KEY']
    config.git_commit = ENV['GIT_SHA']
  end
end
