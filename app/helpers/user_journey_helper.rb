module UserJourneyHelper
  def pid_step
    your_information_path unless user_session.pid_submitted?
  end
end
