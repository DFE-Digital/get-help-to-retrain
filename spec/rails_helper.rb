require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'simplecov'
require 'vcr'
SimpleCov.start

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

VCR.configure do |vcr|
  vcr.cassette_library_dir = 'spec/fixtures/vcr'
  vcr.hook_into :webmock
  vcr.ignore_localhost = true
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include FactoryBot::Syntax::Methods

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  DatabaseCleaner.allow_remote_database_url = true

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.around :each, vcr: true do |example|
    VCR.use_cassette(example.metadata[:full_description].parameterize) do
      example.run
    end
  end

  config.around :all, vcr_all: true do |examples|
    VCR.use_cassette(examples.metadata[:described_class].name.parameterize) do
      examples.run
    end
  end
end
