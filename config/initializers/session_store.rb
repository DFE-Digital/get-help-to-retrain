unless Rails.configuration.admin_mode
  Rails.application.config.session_store :active_record_store, key: '_get_help_to_retrain_session'
  ActionDispatch::Session::ActiveRecordStore.session_class = Session
end
