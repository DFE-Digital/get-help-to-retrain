module Admin
  class UserSessionsController < ApplicationController
    def destroy
      admin_user_session.user_id = nil

      redirect_to root_path
    end

    def sign_in
      return redirect_to root_path if admin_current_user.present?

      render layout: 'admin/application'
    end
  end
end
