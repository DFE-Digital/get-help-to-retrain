if defined?(ActiveAdmin)
  ActiveAdmin.setup do |config|
    # Title displayed in admin section
    config.site_title = 'No train, no gain Admin'

    # Completely disable comments functionality
    config.comments = false

    # Localize Date/Time Format
    config.localize_format = :long
  end
end
