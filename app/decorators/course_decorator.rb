# TODO: Most of the xpath expressions within this class will be migrated to JobProfileScraper over time
# which should remove the need to disable rubocop rules here.
class CourseDecorator < SimpleDelegator
  include ActionView::Helpers::TagHelper

  def full_address
    full_street_address
      .concat('<br>')
      .concat(full_region)
      .concat('<br>')
      .concat(postcode)
      .html_safe
  end

  private

  def full_street_address
    [address_line_1, address_line_2].compact.join(', ')
  end

  def full_region
    [town, county].compact.join(', ')
  end
end
