class UsersController < ApplicationController
  def new
    @user = User.new
    user_session.registration_triggered_from(request.referer)
  end
end
