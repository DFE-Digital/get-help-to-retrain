# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.config.content_security_policy do |policy|
  policy.font_src    :self, :https, :data
  policy.img_src     :self, :https, :data
  policy.object_src  :none
  policy.script_src  :self,
                     'https://www.google-analytics.com',
                     'https://www.google-analytics.com/analytics.js',
                     'https://www.googletagmanager.com',
                     'https://connect.facebook.net',
                     "'sha256-Dxc0MAwW+c3gw7Gc7P3nkQRqGGCluJ1IWIwINlTBthQ='", # gtag inline JS SHA (DEV, QA)
                     "'sha256-mj+puRQe0IXRcvvMkkPqZb+Vrr49Swt4nVDcYiOc0qA='", # gtag inline JS SHA (UAT)
                     "'sha256-iWZlDtXlrEVKWt8xS+oXaedWXwdpr618P2kN/EXVkfA='", # gtag inline JS SHA (PRD)
                     "'sha256-IWjjekDxqqURWMjVH447fuaAvoZKwpDwLS0ZdcJ+Ey4='" # template body inline JS
  # If you are using webpack-dev-server then specify webpack-dev-server host
  policy.connect_src :self, :https, 'http://localhost:3035', 'ws://localhost:3035' if Rails.env.development?

  # Specify URI for violation reports
  if Rails.configuration.security_header_endpoint.present?
    policy.report_uri Rails.configuration.security_header_endpoint
  end
end

# If you are using UJS then enable automatic nonce generation
Rails.application.config.content_security_policy_nonce_generator = ->(_request) { SecureRandom.base64(16) }

# Set the nonce only to specific directives
# Rails.application.config.content_security_policy_nonce_directives = %w(script-src)

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true
