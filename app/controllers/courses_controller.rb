class CoursesController < ApplicationController
  before_action :handle_missing_courses

  def index
    @search = CourseGeospatialSearch.new(
      postcode: courses_params[:postcode],
      topic: courses_params[:topic_id]
    )
    @courses = @search.find_courses.map { |c| CourseDecorator.new(c) }
  end

  private

  def handle_missing_courses
    protect_feature(:course_directory)
  end

  def courses_params
    params.permit(:postcode, :topic_id)
  end
end
