class CourseDetails
  attr_reader :body

  def initialize(body)
    @body = body
  end

  def name
    body['courseName']
  end

  def qualification_name
    body.dig('qualification', 'learnAimRefTitle')
  end

  def qualification_level
    body.dig('qualification', 'qualificationLevel')
  end

  def study_mode
    body['studyMode']
  end

  def attendance_pattern
    body['attendancePattern']
  end

  def delivery_mode
    body['deliveryMode']
  end

  def cost
    body['cost']
  end

  def start_date
    body['startDate']
  end

  def flexible_start_date
    body['flexibleStartDate']
  end

  def description
    body.dig('course', 'courseDescription')
  end

  def website
    body['courseURL']
  end

  def provider_name
    body.dig('provider', 'providerName')
  end

  def provider_address_line_1
    body.dig('provider', 'addressLine1')
  end

  def provider_address_line_2
    body.dig('provider', 'addressLine2')
  end

  def provider_town
    body.dig('provider', 'town')
  end

  def provider_postcode
    body.dig('provider', 'postcode')
  end

  def provider_county
    body.dig('provider', 'county')
  end

  def provider_email
    body.dig('provider', 'email')
  end

  def provider_phone
    body.dig('provider', 'telephone')
  end

  def provider_website
    body.dig('provider', 'website')
  end

  def venue_website
    body.dig('venue', 'website')
  end
end
