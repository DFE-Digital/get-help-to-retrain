class PagesController < ApplicationController
  def show
    render template: "pages/#{params[:page]}"
  end

  def location_eligibility
    track_event(:pages_location_eligibility_search, search: postcode) if postcode.present?

    @search = CourseGeospatialSearch.new(postcode: postcode)

    location_eligibility_through_courses if postcode.present? && @search.valid?
  rescue CourseGeospatialSearch::GeocoderAPIError
    redirect_to postcode_search_error_path
  end

  private

  def postcode
    eligibility_params[:postcode]
  end

  def eligibility_params
    params.permit(:postcode)
  end

  def location_eligibility_through_courses
    @search.find_courses.any? ? redirect_to(task_list_path) : redirect_to(location_ineligible_path)
  end
end
