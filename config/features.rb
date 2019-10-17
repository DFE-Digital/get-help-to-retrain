Flipflop.configure do
  strategy :test unless Rails.env.production?
  strategy :query_string unless Rails.env.production?
  strategy :split_client, api_key: ENV['SPLIT_API_KEY'] if ENV['SPLIT_API_KEY'].present?

  feature :foo, description: 'Example feature flag', default: true
  feature :health_check, description: 'Dummy feature for split.io health check'
  feature :action_plan, description: 'Action plan and updated job profile page'
end
