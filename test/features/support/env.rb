require 'capybara/cucumber'
require 'webdrivers/chromedriver'
require 'webdrivers/geckodriver'
require 'webdrivers/iedriver'
 
Capybara.default_driver = :selenium

Capybara.configure do |config|
    config.default_driver = :selenium_chrome_headless
    config.app_host = 'http://localhost:3000'
    config.default_max_wait_time = 5
end
