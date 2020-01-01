module Admin
  module AuthenticationHelper
    # Override active admin helper method that ensures user is authenticated before accessing the dashboard
    def authenticate_active_admin_user!
      redirect_to admin_sign_in_path unless admin_current_user.present?
    end

    # Override active admin helper method that ensures we have access to a current_user
    def admin_current_user
      if admin_user_session.user_id.present?
        @admin_current_user ||= ::AdminUser.find_by(resource_id: session[:admin_user_id])
      else
        @admin_current_user = nil
      end
    end

    # Handle session for active admin users separately
    def admin_user_session
      @admin_user_session ||= ::AdminUserSession.new(session)
    end
  end
end
