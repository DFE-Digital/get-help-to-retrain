namespace :data_import do
  # bin/rails "data_import:import_job_growth[filename.xlsx]"
  desc 'Import job growth data from Excel spreadsheet'
  task :import_job_growth, [:filename] => [:environment] do |_task, args|
    filename = args[:filename]
    abort 'No spreadsheet filename provided' unless filename.present?

    print "Importing job growth data from #{filename}..."
    importer = JobProfileImportService.new
    importer.import_growth(filename)

    print "\nResults:\n#{importer.import_growth_stats}"
  end
end
