require 'flipflop/split_client_strategy'

Flipflop.configure do
  strategy :test if Rails.env.test?
  strategy :query_string
  strategy :split_client, api_key: ENV['SPLIT_API_KEY'] if ENV['SPLIT_API_KEY'].present?

  feature :foo, description: 'Example feature flag', default: true
  feature :course_directory, description: 'Training courses feature'
end
