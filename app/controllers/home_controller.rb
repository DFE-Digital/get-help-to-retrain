class HomeController < ApplicationController
  def index
    @pid_or_task_list_path = helpers.pid_step || task_list_path
  end
end
