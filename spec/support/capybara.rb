RSpec.configure do |config|
  if ENV['SELENIUM_REMOTE_ADDRESS']
    Capybara.register_driver :headless_chrome do |app|
      options = Selenium::WebDriver::Chrome::Options.new(
        args: %w[headless disable-gpu window-size=1280,2000 no-sandbox]
      )
      capabilities = Selenium::WebDriver::Remote::Capabilities.chrome

      Capybara::Selenium::Driver.new(
        app,
        browser: :remote,
        url: 'http://localhost:4444/wd/hub',
        desired_capabilities: capabilities,
        options: options
      )
    end

    Capybara.app_host = "http://#{ENV['SELENIUM_REMOTE_ADDRESS']}:3000"
    Capybara.javascript_driver = :headless_chrome
    Capybara.server_host = '0.0.0.0'
    Capybara.server_port = '3000'
  else
    Capybara.javascript_driver = :selenium_chrome_headless
  end

  config.before(:all, type: :feature) do
    PrimaryActiveRecordBase.connection.reconnect!
    RestrictedActiveRecordBase.connection.reconnect!
  end

  config.prepend_after(:each, type: :feature) do
    Capybara.reset_sessions!
  end
end
