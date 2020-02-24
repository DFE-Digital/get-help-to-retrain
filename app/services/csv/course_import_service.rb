module Csv
  class CourseImportService
    def initialize
      not_production!
      @errors = []
    end

    def import(folder)
      delete_old_records!
      create_records_from!(folder)
    end

    def import_stats
      {
        providers_total: Csv::Provider.count
        # courses_total: Csv::Course.count,
        # filtered_courses_total: Csv::CourseLookup.count,
        # filtered_courses_with_geocoding: Course.geocoded.count,
        # filtered_courses_without_geocoding: courses_without_geocoding.count,
        # errors: @errors.count
      }
    end

    private

    def not_production!
      raise 'Not to be run in production' if Rails.env.production?
    end

    def delete_old_records!
      Csv::Provider.delete_all
      Csv::Course.delete_all
      Csv::Opportunity.delete_all
      Csv::OpportunityStartDate.delete_all
      Csv::Venue.delete_all
      Csv::CourseLookup.delete_all
    end

    def create_records_from!(folder)
      Csv::Persistor::Provider.new(folder).persist!
      # Csv::Persistor::Venue.new(folder).persist!
      # Csv::Persistor::Course.new(folder).persist!
      # Csv::Persistor::Opportunity.new(folder).persist!
      # Csv::Persistor::OpportunityStartDate.new(folder).persist!
      # Csv::Persistor::CourseLookup.new.persist!
    end
  end
end
