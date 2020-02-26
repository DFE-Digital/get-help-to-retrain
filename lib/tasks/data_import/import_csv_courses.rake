namespace :data_import do
  # bin/rails "data_import:import_csv_courses[folder]"
  desc 'Import csv courses from OpenData courses folder'
  task :import_csv_courses, [:folder] => [:environment] do |_task, args|
    unless (folder = args[:folder]).present?
      print 'No csv folder name provided'
      exit(false)
    end

    print "Importing csv courses from #{folder}..."

    importer = Csv::CourseImportService.new
    importer.import(folder)

    print "\nResults:\n#{importer.import_stats}"
  end
end
