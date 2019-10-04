namespace :data_import do
  # bin/rails "data_import:import_job_growth[filename.xlsx]"
  desc 'Import job growth data from Excel spreadsheet'
  task :import_job_growth, [:filename] => [:environment] do |_task, args|
    unless (filename = args[:filename]).present?
      print 'No spreadsheet filename provided'
      exit(false)
    end

    print "Importing job growth data from #{filename}..."
    importer = JobProfileImportService.new
    importer.import_growth(filename)

    print "\nResults:\n#{importer.import_growth_stats}"
  end
end
