module Admin
  module AuthenticationHelper
    # Override active admin helper method that ensures user is authenticated before accessing the dashboard
    def authenticate_active_admin_user!
      redirect_to admin_sign_in_path unless admin_current_user.present?
    end

    # Override active admin helper method that ensures we have access to a current_user
    def admin_current_user
      @admin_current_user ||= begin
        return unless admin_user_session.user_id.present?

        ::AdminUser.find_by(resource_id: session[:admin_user_id])
      end
    end

    # Handle session for active admin users separately
    def admin_user_session
      @admin_user_session ||= ::AdminUserSession.new(session)
    end

    # Needed by papertrail for auditing
    def user_for_paper_trail
      admin_current_user.present? ? admin_current_user.try(:id) : 'Unauthenticated user'
    end

    # Send custom tracking events to PaperTrail
    def track_custom_event(item_type:, event:, item_id: nil, changes: nil)
      PaperTrail::Version.create(
        item_type: item_type,
        whodunnit: admin_current_user.id,
        event: event,
        item_id: item_id,
        object_changes: changes
      )
    end

    # Link to whodunnit resource
    def whodunnit_for(version:)
      return 'Platform' unless version.whodunnit.present?

      link_to(version.whodunnit, admin_admin_user_path(version.whodunnit))
    end
  end
end
