class PagesController < ApplicationController
  def show
    render template: "pages/#{params[:page]}"
  end

  def location_eligibility # rubocop:disable Metrics/AbcSize
    protect_feature(:location_eligibility)
    return unless eligibility_params[:postcode]

    courses = Course.find_courses_near(
      postcode: eligibility_params[:postcode]
    )
    courses.any? ? (redirect_to task_list_path) : (redirect_to root_path)
  rescue CourseGeospatialSearch::GeocoderAPIError
    flash.now[:error] = t('courses.api_down_error')
  rescue CourseGeospatialSearch::InvalidPostcodeError
    flash.now[:error] = t('courses.invalid_postcode_error')
  end

  private

  def eligibility_params
    params.permit(:postcode)
  end
end
