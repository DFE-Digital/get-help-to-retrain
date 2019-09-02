Flipflop.configure do
  strategy :test unless Rails.env.production?
  strategy :query_string unless Rails.env.production?
  strategy :split_client, api_key: ENV['SPLIT_API_KEY'] if ENV['SPLIT_API_KEY'].present?

  feature :foo, description: 'Example feature flag', default: true
  feature :skills_builder_v2, description: 'Skills builder V2 feature'
end
