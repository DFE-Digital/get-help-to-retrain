Flipflop.configure do
  strategy :test unless Rails.env.production?
  strategy :query_string unless Rails.env.production?
  strategy :split_client, api_key: ENV['SPLIT_API_KEY'] if ENV['SPLIT_API_KEY'].present?

  feature :foo, description: 'Example feature flag', default: true
  feature :health_check, description: 'Dummy feature for split.io health check'
  feature :skills_builder_v2, description: 'Skills builder V2 feature'
  feature :user_personal_data, description: 'User personal data collection feature'
  feature :user_authentication, description: 'User authentication and save progress feature'
  feature :next_steps_v2, description: 'Next steps with new regions and content feature'
  feature :spell_check, description: 'Spell checking capability using Bing Spell Check API'
end
