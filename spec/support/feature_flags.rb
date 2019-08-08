module FeatureFlags
  def enable_feature!(*feature_names)
    switch_feature!(feature_names, true)
  end

  def disable_feature!(*feature_names)
    switch_feature!(feature_names, false)
  end

  def switch_feature!(feature_names, enabled)
    test_strategy = Flipflop::FeatureSet.current.test!
    feature_names.each do |feature|
      test_strategy.switch!(feature, enabled)
    end
  end
end

RSpec.configure do |config|
  config.include FeatureFlags
end
