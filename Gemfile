source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version').chomp

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'

# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'

# Use Puma as the app server
gem 'puma', '~> 3.12'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Manage multiple processes i.e. web server and webpack
gem 'foreman'

# Canonical meta tag
gem 'canonical-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Security scanner
  gem 'brakeman', '~> 4.5'

  # GOV.UK interpretation of rubocop for linting Ruby
  gem 'govuk-lint'

  # Debugging
  gem 'pry-byebug'

  # Testing framework
  gem 'rspec-rails', '~> 3.8'

  # Handle env vars
  gem 'dotenv-rails'

  # Test data
  gem 'factory_bot_rails', '~> 5.0'
  gem 'faker', '~> 1.9'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Ruby code analyzer and formatter
  gem 'rubocop', '~> 0.68'
  gem 'rubocop-rspec', '~> 1.32'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'

  gem 'cucumber-rails', require: false

  gem 'database_cleaner', '~> 1.7'

  gem 'selenium-webdriver', '~> 3.142', '>= 3.142.3'

  # Easy installation and use of browser drivers to run system tests with different browsers
  gem 'webdrivers', '~> 4.0'

    # Test coverage reporting
  gem 'simplecov', '~> 0.16', require: false

  # Web request caching for tests
  gem 'vcr', '~> 5.0', require: false
  gem 'webmock', '~> 3.6', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
