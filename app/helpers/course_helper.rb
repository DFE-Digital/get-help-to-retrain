module CourseHelper
  def format_date(start_date, flexible_start_date)
    return DateTime.parse(start_date).strftime('%d %b %Y') if start_date

    flexible_start_date ? 'Flexible start date' : 'Contact provider'
  rescue StandardError => e
    Rails.logger.error("Course details - start date error: #{e.inspect}")
    nil
  end
end
