namespace :data_import do
  # bin/rails "data_import:import_job_additional_data[filename.xlsx]"
  desc 'Import job additional data from Excel spreadsheet'
  task :import_job_additional_data, [:filename] => [:environment] do |_task, args|
    unless (filename = args[:filename]).present?
      print 'No spreadsheet filename provided'
      exit(false)
    end

    print "Importing job profile additional data from #{filename}..."
    importer = JobProfileImportService.new
    importer.import_additional_data(filename)

    print "\nResults:\n#{importer.import_additional_data_stats}"
  end
end
