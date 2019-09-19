class CustomFormatter < ActiveSupport::Logger::SimpleFormatter
  def call(severity, time, progname, msg)
    msg = hide_token(timestamp) if msg.include?('Started GET "/sign-in/')

    super
  end

  private

  def hide_token(timestamp)
    "Started GET \"/sign-in/[FILTERED]\" at #{timestamp}"
  end
end
