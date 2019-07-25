class ApplicationController < ActionController::Base
  private

  def protect_feature(feature)
    redirect_to task_list_path unless Flipflop.enabled?(feature)
  end
end
