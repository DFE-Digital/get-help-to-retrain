class SearchCourseDecorator < SimpleDelegator
  include ActionView::Helpers::TagHelper

  def full_address
    return unless address

    address
      .gsub(%r{n/a(, )?}i, '')
  end
end
