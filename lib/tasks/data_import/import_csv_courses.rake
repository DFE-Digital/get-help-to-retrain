namespace :data_import do
  # bin/rails "data_import:import_csv_courses[folder]"
  desc 'Import csv courses from OpenData courses folder'
  task :import_csv_courses, [:folder] => [:environment] do |_task, args|
    unless (folder = args[:folder]).present?
      print 'No csv folder name provided'
      exit(false)
    end

    print "Importing csv courses from #{folder}..."

    Csv::CourseDetail.delete_all
    Csv::Opportunity.delete_all
    Csv::OpportunityStartDate.delete_all
    Csv::Provider.delete_all
    Csv::Venue.delete_all
    Csv::Course.delete_all
    importer = Csv::CourseImportService.new
    importer.import(folder)
  end
end
