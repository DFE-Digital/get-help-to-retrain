class SearchCourseDecorator < SimpleDelegator
  include ActionView::Helpers::TagHelper

  def full_address
    return unless address

    address
      .gsub(%r{n/a(, )?}i, '')
  end

  def hours
    course_hours unless course_hours&.downcase == 'undefined'
  end
end
