class SearchCourse
  attr_reader :body

  def initialize(body)
    @body = body
  end

  def name
    body['courseName'].presence
  end

  def provider_name
    body['providerName'].presence
  end

  def course_hours
    body['venueStudyModeDescription'].presence
  end

  def course_type
    body['deliveryModeDescription'].presence
  end

  def address
    body['venueAddress'].presence
  end

  def distance
    body['distance'].presence
  end

  def course_id
    body['courseId'].presence
  end

  def course_run_id
    body['courseRunId'].presence
  end

  def start_date
    body['startDate'].presence
  end

  def flexible_start_date
    body['flexibleStartDate'].presence
  end
end
