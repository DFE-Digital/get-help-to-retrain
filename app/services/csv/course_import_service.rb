module Csv
  class CourseImportService
    def initialize
      not_production!
      @errors = []
    end

    def import(folder)
      Csv::Persistor::Provider.new(folder).persist!
      Csv::Persistor::Venue.new(folder).persist!
      Csv::Persistor::CourseDetail.new(folder).persist!
      Csv::Persistor::Opportunity.new(folder).persist!
      Csv::Persistor::OpportunityStartDate.new(folder).persist!
      # Csv::Persistor::Course.new.persist!
    end

    def import_stats
      {
        courses_total: Csv::CourseDetail.count,
        providers_total: Csv::Provider.count
        # filtered_courses_total: Csv::Course.count,
        # # filtered_courses_with_geocoding: Course.geocoded.count,
        # # filtered_courses_without_geocoding: courses_without_geocoding.count,
        # errors: @errors.count
      }
    end

    private

    def not_production!
      raise 'Not to be run in production' if Rails.env.production?
    end
  end
end
