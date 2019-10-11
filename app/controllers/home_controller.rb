class HomeController < ApplicationController
  def index
    @pid_or_task_list_path = user_session.postcode.present? ? task_list_path : your_information_path
  end
end
