class SessionKlass < SimpleDelegator
  def initialize(session)
    super
  end

  def id
    self[:id]
  end

  def destroy
    clear
  end
end

module SessionHelper
  def create_fake_session(values, versioned: true)
    expected_version = Flipflop.skills_builder_v2? ? 2 : 1
    values.merge!(version: expected_version) if versioned
    SessionKlass.new(values)
  end
end

RSpec.configure do |config|
  config.include SessionHelper
end
