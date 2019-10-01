class HomeController < ApplicationController
  def index
    @postcode_pid_or_task_list_path = helpers.postcode_step || helpers.pid_step || task_list_path
  end
end
