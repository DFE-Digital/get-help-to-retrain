# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require 'ddtrace'

Datadog.configure do |c|
  c.use :rack
  c.analytics_enabled = true
end

use Datadog::Contrib::Rack::TraceMiddleware

# app = proc do |env|
#   [ 200, {'Content-Type' => 'text/plain'}, ['OK'] ]
# end

# run app

run Rails.application
