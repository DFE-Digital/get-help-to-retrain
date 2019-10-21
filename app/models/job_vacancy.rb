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

  def date_posted
    body['posted']
      &.to_time
      &.strftime('%d %B %Y')
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
