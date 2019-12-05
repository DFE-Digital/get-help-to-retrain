class Skill < PrimaryActiveRecordBase
  has_many :job_profile_skills
  has_many :job_profiles, through: :job_profile_skills, inverse_of: :skills

  scope :without_job_profiles, -> { left_outer_joins(:job_profiles).where(job_profiles: { id: nil }) }

  def self.import(names)
    names.map { |name| find_or_create_by(name: name) }
  end

  def self.mapping
    all.each_with_object({}) { |skill, hash| hash[skill.id.to_s] = skill.name }
  end
end
