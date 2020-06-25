namespace :data_import do
  # bin/rails "data_import:import_master_skills_mapping[filename.xlsx]"
  desc 'Import master skills mapping from Excel spreadsheet'
  task :import_master_skills_mapping, [:filename] => [:environment] do |_task, args|
    unless (filename = args[:filename]).present?
      print 'No spreadsheet filename provided'
      exit(false)
    end

    print "Importing mapping data from #{filename}..."

    importer = SkillsMappingImportService.new
    importer.import(filename)

    print "\nResults:\n#{importer.import_stats}"
  end
end
