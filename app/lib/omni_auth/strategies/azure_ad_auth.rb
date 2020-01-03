require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    # Implements an OmniAuth strategy to get a Microsoft Graph
    # compatible token from Azure AD
    class AzureAdAuth < OmniAuth::Strategies::OAuth2
      option :name, :azure_ad_auth

      SITE = 'https://login.microsoftonline.com'.freeze
      MICROSOFT_GRAPH_API_ENDPOINT = 'https://graph.microsoft.com/v1.0/'.freeze

      # Configure the Microsoft identity platform endpoints
      option :client_options,
             site: SITE,
             authorize_url: "/#{Rails.application.config.azure_tenant_id}/oauth2/v2.0/authorize",
             token_url: "/#{Rails.application.config.azure_tenant_id}/oauth2/v2.0/token"

      # Send the scope parameter during authorize
      option :authorize_options, [:scope]

      # Unique ID for the user is the id field
      uid { user_info['id'] }

      # Main user information
      info do
        {
          'name' => user_info['displayName'],
          'email' => user_info['mail']
        }
      end

      # Get additional information after token is retrieved
      extra do
        {
          'raw_info' => user_info,
          'user_roles' => user_roles
        }
      end

      def user_info
        # Get user profile information from the /me endpoint
        @user_info ||= access_token.get("#{MICROSOFT_GRAPH_API_ENDPOINT}/me").parsed
      end

      def user_roles
        # Get user profile information from the /me endpoint
        @user_roles ||= access_token.get("#{MICROSOFT_GRAPH_API_ENDPOINT}/me/memberOf").parsed
      end

      # Override callback URL
      # OmniAuth by default passes the entire URL of the callback, including
      # query parameters. Azure fails validation because that doesn't match the
      # registered callback.
      def callback_url
        options[:redirect_uri]
      end
    end
  end
end
