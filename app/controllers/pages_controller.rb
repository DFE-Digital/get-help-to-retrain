class PagesController < ApplicationController
  def show
    render template: "pages/#{params[:page]}"
  end

  def location_eligibility
    protect_feature(:location_eligibility)
    if course_geospatial_search.errors.any?
      @search = course_geospatial_search
    else
      course_geospatial_search.courses.any? ? (redirect_to task_list_path) : (redirect_to root_path)
    end
  end

  private

  def eligibility_params
    params.permit(:postcode)
  end

  def course_geospatial_search
    @course_geospatial_search ||= CourseGeospatialSearch.new(
      postcode: eligibility_params[:postcode]
    )
  end
end
