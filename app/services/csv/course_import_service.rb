module Csv
  class CourseImportService
    def initialize
      not_production!
      @errors = []
    end

    def import(folder)
      detele_old_records!
      create_records_from!(folder)
    end

    def import_stats
      {
        providers_total: Csv::Provider.count,
        courses_total: Csv::Course.count
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

    def create_records_from!(folder)
      klass_list.each do |klass|
        path = File.join(folder, klass::FILENAME)
        CSV.foreach(path, headers: true) do |row|
          klass.new(row).persist!
        end
      end
    end

    def detele_old_records!
      klass_list_2.each do |klass|
        klass.delete_all
      end
    end

    def klass_list
      [
        Csv::Persistor::Provider,
        Csv::Persistor::Venue,
        Csv::Persistor::Course
        # Csv::Opportunity,
        # Csv::OpportunityStartDate,
        # Csv::CourseLookup,
      ]
    end

    def klass_list_2
      [
        Csv::Provider,
        Csv::Venue,
        Csv::Course,
        Csv::Opportunity,
        Csv::OpportunityStartDate,
        Csv::CourseLookup
      ]
    end
  end
end
