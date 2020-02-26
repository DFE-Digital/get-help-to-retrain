class CoursesController < ApplicationController
  def index
    Flipflop.csv_courses? ? find_csv_courses : find_courses
  end

  private

  def find_courses
    track_event(:courses_index_search, postcode) if postcode.present?

    @search = CourseGeospatialSearch.new(
      postcode: postcode,
      topic: courses_params[:topic_id]
    )

    user_session.postcode = postcode if postcode && @search.valid?

    @courses = Kaminari.paginate_array(course_search).page(params[:page])
  rescue CourseGeospatialSearch::GeocoderAPIError
    redirect_to course_postcode_search_error_path
  end

  def find_csv_courses
    track_event(:courses_index_search, postcode) if postcode.present?

    @search = Csv::CourseGeospatialSearch.new(
      postcode: postcode,
      topic: courses_params[:topic_id]
    )

    user_session.postcode = postcode if postcode && @search.valid?

    @courses = Kaminari.paginate_array(csv_course_search).page(params[:page])
  rescue Csv::CourseGeospatialSearch::GeocoderAPIError
    redirect_to course_postcode_search_error_path
  end

  def postcode
    @postcode ||= courses_params[:postcode] || user_session.postcode
  end

  def courses_params
    params.permit(:postcode, :topic_id)
  end

  def course_search
    @search.find_courses.map { |c| CourseDecorator.new(c) }
  end

  def csv_course_search
    @search.find_courses.map { |c| Csv::CourseLookupDecorator.new(c) }
  end
end
