class CoursesController < ApplicationController
  DISTANCE = [
    ['Up to 10 miles', '10'], ['Up to 20 miles', '20'], ['Up to 30 miles', '30'], ['Up to 40 miles', '40']
  ].freeze

  DELIVERY_TYPES = [
    %w[All all], ['Classroom based', '1'], %w[Online 2], ['Work based', '3']
  ].freeze

  HOURS = [
    %w[All all], ['Full time', '1'], ['Part time', '2'], %w[Flexible 3]
  ].freeze

  def index
    Flipflop.csv_courses? ? find_csv_courses : find_courses
  end

  def show
    @decorated_course_details = CourseDetailsDecorator.new(course_details)
  rescue FindACourseService::APIError
    redirect_to courses_near_me_error_path
  end

  private

  def find_courses
    track_event(:courses_index_search, postcode) if postcode.present?

    @search = CourseGeospatialSearch.new(
      postcode: postcode,
      topic: courses_params[:topic_id]
    )

    user_session.postcode = postcode if postcode && @search.valid?

    @courses = Kaminari.paginate_array(course_search).page(courses_params[:page])
  rescue CourseGeospatialSearch::GeocoderAPIError
    redirect_to course_postcode_search_error_path
  end

  def find_csv_courses
    track_course_filters
    persist_valid_filters_on_session

    @courses = Kaminari .paginate_array(csv_course_search, total_count: search.count)
                        .page(courses_params[:page])
  rescue CourseSearch::GeocoderAPIError
    redirect_to course_postcode_search_error_path
  rescue FindACourseService::APIError
    redirect_to courses_near_me_error_path
  end

  def postcode
    @postcode ||= courses_params[:postcode] || user_session.postcode
  end

  def distance
    @distance ||= courses_params[:distance] || user_session.distance
  end

  def courses_params
    params.permit(
      :postcode, :topic_id, :hours, :delivery_type,
      :distance, :page, :course_id, :course_run_id,
      :authenticity_token
    )
  end

  def course_search
    @search.find_courses.map { |c| CourseDecorator.new(c) }
  end

  def csv_course_search
    search.search.map { |c| SearchCourseDecorator.new(c) }
  end

  def search
    @search ||= CourseSearch.new(
      postcode: postcode,
      topic: courses_params[:topic_id],
      options: {
        distance: courses_params[:distance],
        hours: courses_params[:hours],
        delivery_type: courses_params[:delivery_type],
        page: courses_params[:page]
      }
    )
  end

  def course_details_api_response
    FindACourseService.new.details(
      course_id: courses_params[:course_id],
      course_run_id: courses_params[:course_run_id]
    )
  end

  def course_details
    CourseDetails.new(course_details_api_response)
  end

  def persist_valid_filters_on_session
    return unless search.valid?

    user_session.postcode = postcode if postcode
    user_session.distance = distance if distance
  end

  def track_course_filters # rubocop:disable Metrics/MethodLength
    track_event(:courses_index_search, postcode) if postcode.present?
    track_course_filter_for(
      parameter: courses_params[:delivery_type],
      value_mapping: DELIVERY_TYPES,
      label: 'events.course_type_filter'
    )
    track_course_filter_for(
      parameter: courses_params[:hours],
      value_mapping: HOURS,
      label: 'events.course_hours_filter'
    )
  end
end
