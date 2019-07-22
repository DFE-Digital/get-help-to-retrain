class CoursesController < ApplicationController
  before_action :handle_missing_courses

  def index # rubocop:disable Metrics/AbcSize
    @courses = Course.find_courses_near(
      postcode: params[:postcode],
      topic: params[:topic_id]
    ).map { |c| CourseDecorator.new(c) }
  rescue CourseGeospatialSearch::GeocoderAPIError
    flash.now[:error] = t('courses.api_down_error')
    @courses = Course.all.map { |c| CourseDecorator.new(c) }
  rescue CourseGeospatialSearch::InvalidPostcodeError
    flash.now[:error] = t('courses.invalid_postcode_error')
    @courses = Course.all.map { |c| CourseDecorator.new(c) }
  end

  private

  def handle_missing_courses
    redirect_to task_list_path if Course.count.zero?
  end
end
