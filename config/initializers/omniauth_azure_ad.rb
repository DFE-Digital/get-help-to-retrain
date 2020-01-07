require 'omni_auth/strategies/azure_ad_auth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :azure_ad_auth,
           Rails.application.config.azure_client_id,
           Rails.application.config.azure_client_secret,
           scope: Rails.application.config.azure_scopes
end
