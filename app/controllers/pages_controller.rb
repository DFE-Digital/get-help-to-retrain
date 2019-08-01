class PagesController < ApplicationController
  def show
    render template: "pages/#{params[:page]}"
  end

  def location_eligibility
    @search = CourseGeospatialSearch.new(
      postcode: eligibility_params[:postcode]
    )

    location_eligibility_through_courses if eligibility_params[:postcode].present? && @search.valid?
  rescue CourseGeospatialSearch::GeocoderAPIError
    redirect_to postcode_search_error_path
  end

  private

  def eligibility_params
    params.permit(:postcode)
  end

  def location_eligibility_through_courses
    @search.find_courses.any? ? redirect_to(task_list_path) : redirect_to(location_ineligible_path)
  end
end
