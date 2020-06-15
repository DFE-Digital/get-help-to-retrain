namespace :data_import do
  # bin/rails "data_import:import_job_growth[filename.xlsx]"
  desc 'Import master skills mapping from Excel spreadsheet'
  task :import_master_skills_mapping, [:filename] => [:environment] do |_task, args|
    unless (filename = args[:filename]).present?
      print 'No spreadsheet filename provided'
      exit(false)
    end

    print "Importing mapping data from #{filename}..."
    # This will be moved to a service
    file = Roo::Spreadsheet.open(filename)

    skills = Skill.all

    mapping = file.each_with_object({}) do |row, hash|
      next if row == ['Skill Name', 'Onet Element Id', 'Master Skill']

      hash[row[0]] = row[2]
    end

    skills.each do |skill|
      skill.master_name = mapping[skill.name].present? ? mapping[skill.name] : skill.name
      skill.save
    end

    ### Populating jamie's tables to implement his solution as well with the extra tables
    SkillVariant.delete_all
    mapping.keys.each do |key|
      SkillVariant.create(
        variant_name: key,
        master_name: mapping[key]
      )
    end
  end
end
