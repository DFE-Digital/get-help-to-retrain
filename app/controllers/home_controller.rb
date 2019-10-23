class HomeController < ApplicationController
  def index
    @pid_or_task_list_path = pid_or_task_list_path
  end

  private

  def pid_or_task_list_path
    if cookies['_get_help_to_retrain_session'].blank? || user_session.postcode.blank?
      your_information_path
    else
      task_list_path
    end
  end
end
