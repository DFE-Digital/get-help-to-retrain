class V2Skill < PrimaryActiveRecordBase
  has_many :v2_job_profile_skills
  has_many :v2_job_profiles, through: :v2_job_profile_skills, inverse_of: :v2_skills

  scope :without_job_profiles, -> { left_outer_joins(:v2_job_profiles).where(v2_job_profiles: { id: nil }) }

  has_paper_trail

  def self.import(names)
    names.map { |name| find_or_create_by(name: name) }
  end

  def self.names_that_include(skill_ids)
    mapping.slice(*skill_ids).values
  end

  def self.names_that_exclude(skill_ids)
    mapping.except(*skill_ids).values
  end

  def self.mapping
    all.each_with_object({}) { |skill, hash| hash[skill.id.to_s] = skill.name }
  end
end
