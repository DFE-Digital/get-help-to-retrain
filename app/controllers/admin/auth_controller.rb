module Admin
  class AuthController < ApplicationController
    def callback
      admin_user = ::AdminUser.from_omniauth(omniauth_hash)

      if admin_user.roles.present? && admin_user.save
        admin_user_session.user_id = admin_user.resource_id

        redirect_to root_path
      else
        redirect_to admin_sign_in_path, alert: t('active_admin.errors.authentication')
      end
    end

    private

    def omniauth_hash
      @omniauth_hash ||= request.env['omniauth.auth']
    end
  end
end
