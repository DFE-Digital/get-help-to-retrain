class SkillsMappingImportService
  SEARCH_COLUMN_HEADINGS = {
    skill_name: 'Skill Name',
    onet_element_id: 'Onet Element Id',
    master_skill: 'Master Skill'
  }.freeze

  def initialize
    not_production!
  end

  def import(filename)
    file = Roo::Spreadsheet.open(filename)
    sheet = file.sheet('Sheet1')

    Skill.update_all(master_name: nil)

    update_skills_mapping_from(sheet)
  end

  def import_stats
    {
      skills_with_synonyms: Skill.where('name != master_name').count,
      skills_without_synonyms: Skill.where('name = master_name').count,
      unmapped_skills: Skill.where(master_name: nil).count
    }
  end

  private

  def build_skills_mapping_from(sheet)
    sheet.each(SEARCH_COLUMN_HEADINGS).each_with_object({}) do |data, mapping|
      next if data == SEARCH_COLUMN_HEADINGS

      mapping[data[:skill_name]] = data[:master_skill]
    end
  end

  def update_skills_mapping_from(sheet)
    mapped_skills = build_skills_mapping_from(sheet)

    Skill.all.each do |skill|
      skill.master_name = mapped_skills[skill.name].present? ? mapped_skills[skill.name] : skill.name
      skill.save
    end
  end

  def not_production!
    raise 'Not to be run in production' if Rails.env.production?
  end
end
