if defined?(ActiveAdmin)
  ActiveAdmin.setup do |config|
    # Title displayed in admin section
    config.site_title = 'Get Help To Retrain Admin'

    # Completely disable comments functionality
    config.comments = false

    # Localize Date/Time Format
    config.localize_format = :long

    # Override the active admin's method that ensures user is authenticated
    config.authentication_method = :authenticate_active_admin_user!

    # Override the active admin's method that ensures presence of a current_user
    config.current_user_method = :admin_current_user

    # Define the active admin's logout path
    config.logout_link_path = :admin_sign_out_path
  end
end
