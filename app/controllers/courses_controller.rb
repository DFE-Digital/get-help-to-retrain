class CoursesController < ApplicationController
  before_action :handle_missing_courses

  def show
    @courses = Course.where(topic: params[:id]).map { |c| CourseDecorator.new(c) }

    raise ActionController::RoutingError.new('Page Not Found') unless @courses.any?
  end

  private

  def handle_missing_courses
    redirect_to task_list_path if Course.count.zero?
  end
end
