module Admin
  class UserSessionsController < ApplicationController
    def destroy
      admin_user_session.user_id = nil
      admin_user_session.user_roles = nil

      redirect_to root_path
    end
  end
end
