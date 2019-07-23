class CoursesController < ApplicationController
  before_action :handle_missing_courses

  def index # rubocop:disable Metrics/AbcSize
    @courses = Course.find_courses_near(
      postcode: courses_params[:postcode],
      topic: courses_params[:topic_id]
    ).map { |c| CourseDecorator.new(c) }
  rescue CourseGeospatialSearch::GeocoderAPIError
    flash.now[:error] = t('courses.api_down_error')
    @courses = all_courses
  rescue CourseGeospatialSearch::InvalidPostcodeError
    flash.now[:error] = t('courses.invalid_postcode_error')
    @courses = all_courses
  end

  private

  def handle_missing_courses
    redirect_to task_list_path if Course.count.zero?
  end

  def all_courses
    Course.all.map { |c| CourseDecorator.new(c) }
  end

  def courses_params
    params.permit(:postcode, :topic_id)
  end
end
