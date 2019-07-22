if defined?(ActiveAdmin)
  ActiveAdmin.setup do |config|
    # Title displayed in admin section
    config.site_title = 'Get Help To Retrain Admin'

    # Completely disable comments functionality
    config.comments = false

    # Localize Date/Time Format
    config.localize_format = :long
  end
end
