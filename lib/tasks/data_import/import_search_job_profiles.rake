namespace :data_import do
  # bin/rails "data_import:import_search_job_profiles[filename.xlsx]"
  desc 'Import hierarchy and sector values from Excel spreadsheet'
  task :import_search_job_profiles, [:filename] => [:environment] do |_task, args|
    unless (filename = args[:filename]).present?
      print 'No spreadsheet filename provided'
      exit(false)
    end

    print "Importing job profile values from #{filename}..."
    importer = JobProfileSearchService.new
    importer.import(filename)

    print "\nResults:\n#{importer.import_stats}"
  end
end
