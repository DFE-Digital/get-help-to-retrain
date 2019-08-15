class CoursesController < ApplicationController
  before_action :handle_missing_courses

  def index
    track_event(:courses_index_search, search: postcode) if postcode.present?

    @search = CourseGeospatialSearch.new(
      postcode: postcode,
      topic: courses_params[:topic_id]
    )
    @courses = @search.find_courses.map { |c| CourseDecorator.new(c) }
  rescue CourseGeospatialSearch::GeocoderAPIError
    redirect_to course_postcode_search_error_path
  end

  private

  def handle_missing_courses
    protect_feature(:course_directory)
  end

  def postcode
    @postcode ||= courses_params[:postcode] || session[:postcode]
  end

  def courses_params
    params.permit(:postcode, :topic_id)
  end
end
