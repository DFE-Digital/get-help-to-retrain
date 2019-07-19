class CoursesController < ActionController::Base
  before_action :handle_missing_courses

  def show
    @courses = Course.where(topic: params[:id])
  end

  private

  def handle_missing_courses
    redirect_to task_list_path if Course.count.zero?
  end
end
