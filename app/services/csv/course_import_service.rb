module Csv
  class CourseImportService
    def initialize
      not_production!
    end

    def import(folder)
      detele_old_records!
      create_records_from!(folder)
      generate_course_lookups!
    end

    def import_stats
      {
        course_lookup_total: Csv::CourseLookup.count,
        english_course_lookups: Csv::CourseLookup.where(subject: 'english').count,
        esol_course_lookups: Csv::CourseLookup.where(subject: 'esol').count,
        maths_course_lookups: Csv::CourseLookup.where(subject: 'maths').count,
        course_lookups_with_geocoding: Csv::CourseLookup.geocoded.count,
        course_lookups_without_geocoding: Csv::CourseLookup.not_geocoded.count
      }
    end

    private

    def not_production!
      raise 'Not to be run in production' if Rails.env.production?
    end

    def create_records_from!(folder)
      classes_to_persist.each do |klass|
        path = File.join(folder, klass::FILENAME)
        CSV.foreach(path, headers: true) do |row|
          klass.new(row).persist!
        end
      end
    end

    def generate_course_lookups!
      Csv::Opportunity.valid_qualifications.find_each do |opportunity|
        Csv::Persistor::CourseLookup.new(opportunity).persist!
      end
    end

    def detele_old_records!
      Csv::Provider.delete_all
      Csv::Venue.delete_all
      Csv::Course.delete_all
      Csv::Opportunity.delete_all
      Csv::OpportunityStartDate.delete_all
      Csv::CourseLookup.delete_all
    end

    def classes_to_persist
      [
        Csv::Persistor::Provider,
        Csv::Persistor::Venue,
        Csv::Persistor::Course,
        Csv::Persistor::Opportunity,
        Csv::Persistor::OpportunityStartDate
      ]
    end
  end
end
