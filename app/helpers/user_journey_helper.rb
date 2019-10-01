module UserJourneyHelper
  def pid_step
    return unless Flipflop.user_personal_data?

    your_information_path unless user_session.pid_submitted?
  end

  def postcode_step
    location_eligibility_path unless user_session.postcode.present?
  end
end
