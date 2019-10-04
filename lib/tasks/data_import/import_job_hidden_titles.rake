namespace :data_import do
  # bin/rails "data_import:import_job_hidden_titles[filename.xlsx]"
  desc 'Import job hidden titles from Excel spreadsheet'
  task :import_job_hidden_titles, [:filename] => [:environment] do |_task, args|
    unless (filename = args[:filename]).present?
      print 'No spreadsheet filename provided'
      exit(false)
    end

    print "Importing job hidden titles data from #{filename}..."
    importer = JobProfileImportService.new
    importer.import_hidden_titles(filename)

    print "\nResults:\n#{importer.import_hidden_titles_stats}"
  end
end
