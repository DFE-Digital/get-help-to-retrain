class JobVacancy
  attr_reader :body

  def initialize(body)
    @body = body
  end

  def title
    body['title']
  end

  def url
    body['url']
  end

  def closing_date
    body['closing'].presence
  end

  def date_posted
    body['posted'].presence
  end

  def company
    body['company'].presence
  end

  def location
    body['location'].presence
  end

  def salary
    body['salary'].presence
  end

  def description
    body['description']
      &.truncate(260)
      .presence
  end
end
