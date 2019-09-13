module AuthenticationHelper
  def user_with_validation
    @user_with_validation ||= begin
      authentication_user.errors.add(:email, flash[:error].first) if flash[:error].present?
      authentication_user
    end
  end

  private

  def authentication_user
    @authentication_user ||= User.new
  end
end
