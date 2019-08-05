class CoursesController < ApplicationController
  before_action :handle_missing_courses

  def index
    track_event(:courses_index_search, search: postcode) if postcode.present?

    @search = CourseGeospatialSearch.new(
      postcode: postcode,
      topic: courses_params[:topic_id]
    )
    @courses = @search.find_courses.map { |c| CourseDecorator.new(c) }
  end

  private

  def handle_missing_courses
    protect_feature(:course_directory)
  end

  def postcode
    courses_params[:postcode]
  end

  def courses_params
    params.permit(:postcode, :topic_id)
  end
end
