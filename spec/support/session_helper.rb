class SessionKlass < SimpleDelegator
  def initialize(session)
    super
  end

  def id
    self[:id]
  end
end

module SessionHelper
  def create_fake_session(values)
    SessionKlass.new(values)
  end
end

RSpec.configure do |config|
  config.include SessionHelper
end
