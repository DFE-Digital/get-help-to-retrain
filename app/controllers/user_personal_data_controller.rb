class UserPersonalDataController < ApplicationController
  def index
    redirect_to task_list_path if user_session.pid_submitted?

    @user_personal_data = UserPersonalData.new
  end

  def create
    @user_personal_data = UserPersonalData.new(personal_data_params)

    if @user_personal_data.save
      user_session.pid = true

      redirect_to task_list_path
    else
      render 'index'
    end
  end

  def skip
    track_event(:user_personal_information_skipped)

    redirect_to task_list_path
  end

  private

  def personal_data_params
    params.require(:user_personal_data).permit(
      :first_name,
      :last_name,
      :postcode,
      :birth_day,
      :birth_month,
      :birth_year,
      :gender
    )
  end
end
