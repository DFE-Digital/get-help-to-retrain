namespace :data_import do
  # bin/rails "data_import:import_courses[filename.xlsx]"
  desc 'Import courses from Excel spreadsheet'
  task :import_courses, [:filename] => [:environment] do |_task, args|
    unless (filename = args[:filename]).present?
      print 'No spreadsheet filename provided'
      exit(false)
    end

    print "Importing courses from #{filename}..."
    Course.delete_all
    importer = CourseImportService.new
    importer.import(filename)

    print "\nResults:\n#{importer.import_stats}"
    if importer.errors.any?
      print "\nErrors:"
      importer.errors.each { |error| print error.inspect }
    end
    if importer.courses_without_geocoding.any?
      print "\nGeocoding failures:"
      importer.courses_without_geocoding.each { |course| print course.inspect }
    end
  end
end
