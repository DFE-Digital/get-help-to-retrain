module FeatureFlags
  def enable_feature!(feature_name)
    switch_feature!(feature_name, true)
  end

  def disable_feature!(feature_name)
    switch_feature!(feature_name, false)
  end

  def switch_feature!(feature_name, enabled)
    test_strategy = Flipflop::FeatureSet.current.test!
    test_strategy.switch!(feature_name, enabled)
  end
end

RSpec.configure do |config|
  config.include FeatureFlags
end
