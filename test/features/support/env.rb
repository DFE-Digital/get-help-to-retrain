require 'capybara/cucumber'
 
Capybara.default_driver = :selenium

Capybara.configure do |config|
    config.app_host = 'http://localhost:3000'
    config.default_max_wait_time = 5
end
