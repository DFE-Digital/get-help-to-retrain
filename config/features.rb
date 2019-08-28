require 'flipflop/split_client_strategy'

Flipflop.configure do
  strategy :test unless Rails.env.production?
  strategy :query_string unless Rails.env.production?
  strategy :split_client, api_key: ENV['SPLIT_API_KEY'] if ENV['SPLIT_API_KEY'].present?

  feature :foo, description: 'Example feature flag', default: true
  feature :course_directory, description: 'Training courses feature'
  feature :location_eligibility, description: 'Location eligibility feature'
  feature :skills_builder, description: 'Skills builder feature'
  feature :skills_builder_v2, description: 'Skills builder V2 feature'
end
