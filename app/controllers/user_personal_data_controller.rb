class UserPersonalDataController < ApplicationController
  def index
    redirect_to task_list_path if user_session.postcode.present?

    @user_personal_data = UserPersonalData.new
  end

  def create
    @user_personal_data = UserPersonalData.new(personal_data_params)

    if @user_personal_data.save
      check_location_eligibility
    else
      render 'index'
    end
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

  def check_location_eligibility
    track_event(:pages_location_eligibility_search, postcode)

    user_session.postcode = postcode

    return redirect_to task_list_path if Flipflop.csv_courses? || search.find_courses.any?

    redirect_to(location_ineligible_path)
  rescue CourseGeospatialSearch::GeocoderAPIError
    redirect_to postcode_search_error_path
  end

  def postcode
    @postcode ||= @user_personal_data.postcode
  end

  def search
    CourseGeospatialSearch.new(postcode: postcode)
  end
end
