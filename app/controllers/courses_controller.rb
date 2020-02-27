class CoursesController < ApplicationController
  def index
    track_event(:courses_index_search, postcode) if postcode.present?

    @search = CourseGeospatialSearch.new(
      postcode: postcode,
      topic: courses_params[:topic_id]
    )

    @course_content = Strapi::ContentTypes::CourseContentType.new.content

    user_session.postcode = postcode if postcode && @search.valid?

    @courses = Kaminari.paginate_array(course_search).page(params[:page])
  rescue CourseGeospatialSearch::GeocoderAPIError
    redirect_to course_postcode_search_error_path
  end

  private

  def postcode
    @postcode ||= courses_params[:postcode] || user_session.postcode
  end

  def courses_params
    params.permit(:postcode, :topic_id)
  end

  def course_search
    @search.find_courses.map { |c| CourseDecorator.new(c) }
  end
end
