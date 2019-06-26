require 'cucumber/rails'
require 'selenium/webdriver'

ActionController::Base.allow_rescue = false

DatabaseCleaner.allow_remote_database_url = true

begin
  DatabaseCleaner.strategy = :truncation
rescue NameError
  raise 'You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it.'
end

Around do |_scenario, block|
  DatabaseCleaner.cleaning(&block)
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu window-size=1280,2000 no-sandbox] }
  )

  Capybara::Selenium::Driver.new app,
                                 browser: :chrome,
                                 desired_capabilities: capabilities
end

# Capybara.javascript_driver = :headless_chrome
Capybara.javascript_driver = :headless_chrome
Capybara.default_driver = :headless_chrome

Cucumber::Rails::Database.javascript_strategy = :truncation
World(FactoryBot::Syntax::Methods)
