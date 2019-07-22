class CoursesController < ApplicationController
  before_action :handle_missing_courses

  def index
    @courses = Course.where(topic: params[:topic_id]).map { |c| CourseDecorator.new(c) }

    redirect_to '/404' unless @courses.any?
  end

  private

  def handle_missing_courses
    redirect_to task_list_path if Course.count.zero?
  end
end
