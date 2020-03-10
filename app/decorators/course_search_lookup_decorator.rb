class CourseSearchLookupDecorator < SimpleDelegator
  include ActionView::Helpers::TagHelper

  def full_address
    address
      .gsub(/(,)(?!.*\1)/, '<br/>')
      .gsub(/(,)(?!.*\1)/, '<br/>')
      .html_safe
  end
end
