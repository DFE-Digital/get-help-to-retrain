require 'cucumber/rails'
ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :truncation
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Around do |scenario, block|
  DatabaseCleaner.cleaning(&block)
end

Capybara.default_driver = :selenium_chrome_headless
Cucumber::Rails::Database.javascript_strategy = :truncation
World(FactoryBot::Syntax::Methods)


