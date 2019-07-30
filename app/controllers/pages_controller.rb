class PagesController < ApplicationController
  def show
    render template: "pages/#{params[:page]}"
  end

  def location_eligibility
    @search = CourseGeospatialSearch.new(
      postcode: eligibility_params[:postcode]
    )

    if eligibility_params[:postcode].present? && @search.valid?
      @search.find_courses.any? ? redirect_to(task_list_path) : redirect_to(root_path)
    end
  end

  private

  def eligibility_params
    params.permit(:postcode)
  end
end
