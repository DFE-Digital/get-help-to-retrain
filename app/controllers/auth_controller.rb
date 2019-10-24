class AuthController < ApplicationController
  def callback
    # This stores all the user information that came from Auth0
    # and the IdP
    data = request.env['omniauth.auth']

    # Save the data in the session
    save_in_session data

    # Redirect to the URL you want after successful auth
    redirect_to task_list_path
  end
end