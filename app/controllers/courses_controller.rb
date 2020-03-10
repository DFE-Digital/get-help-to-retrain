class CoursesController < ApplicationController
  DISTANCE = [
    ['Up to 10 miles', 10],
    ['Up to 20 miles', 20],
    ['Up to 30 miles', 30],
    ['Up to 40 miles', 40]
  ].freeze

  DELIVERY_TYPES = ['All', 'Classroom based', 'Distance learning', 'Online'].freeze
  HOURS = ['All', 'Full time', 'Part time', 'Flexible'].freeze

  def index
    Flipflop.csv_courses? ? find_csv_courses : find_courses
  end

  def show
    @opportunity = Csv::OpportunityDecorator.new(course_opportunity)
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
    geospatial_search
    filter_options

    user_session.postcode = postcode if postcode && @search.valid?
    @courses = Kaminari.paginate_array(csv_course_search).page(params[:page])
  rescue Csv::CourseGeospatialSearch::GeocoderAPIError
    redirect_to course_postcode_search_error_path
  end

  def postcode
    @postcode ||= courses_params[:postcode] || user_session.postcode
  end

  def courses_params
    params.permit(:postcode, :topic_id, :hours, :delivery_type, :distance)
  end

  def course_search
    @search.find_courses.map { |c| CourseDecorator.new(c) }
  end

  def csv_course_search
    @search.find_courses.map { |c| Csv::CourseLookupDecorator.new(c) }
  end

  def geospatial_search
    @search = Csv::CourseGeospatialSearch.new(
      postcode: postcode,
      topic: courses_params[:topic_id],
      options: {
        distance: courses_params[:distance],
        hours: courses_params[:hours],
        delivery_type: courses_params[:delivery_type]
      }
    )
  end

  def filter_options
    @distance_options = helpers.options_for_select(DISTANCE, courses_params[:distance] || 20)
    @delivery_type_options = helpers.options_for_select(DELIVERY_TYPES, courses_params[:delivery_type] || 'All')
    @hours_options = helpers.options_for_select(HOURS, courses_params[:hours] || 'All')
  end

  def course_opportunity
    Csv::Opportunity.find(params[:opportunity_id])
  end
end
