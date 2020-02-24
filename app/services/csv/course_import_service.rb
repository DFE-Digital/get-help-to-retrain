module Csv
  class CourseImportService
    def initialize
      not_production!
    end

    def import(folder)
      delete_old_records!
    end

    def import_stats
      {}
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
  end
end
