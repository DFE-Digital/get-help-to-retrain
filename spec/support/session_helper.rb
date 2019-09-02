class SessionKlass < SimpleDelegator
  def initialize(session)
    super
  end

  def destroy
    clear
  end
end

module SessionHelper
  def create_fake_session(values, version: true)
    expected_version = Flipflop.skills_builder_v2? ? 2 : 1
    values = version ? values.merge(version: expected_version) : values
    SessionKlass.new(values)
  end
end

RSpec.configure do |config|
  config.include SessionHelper
end
