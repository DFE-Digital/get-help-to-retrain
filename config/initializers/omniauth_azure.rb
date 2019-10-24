# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :azure_oauth2,
#     {
#       client_id: ENV['AZURE_CLIENT_ID'],
#       client_secret: ENV['AZURE_CLIENT_SECRET']
#     }
# end

require 'graph_auth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :microsoft_graph_auth,
           ENV['AZURE_CLIENT_ID'],
           ENV['AZURE_CLIENT_SECRET'],
           scope: ENV['AZURE_SCOPES']
end
