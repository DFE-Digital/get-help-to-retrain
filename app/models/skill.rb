class Skill < ApplicationRecord
  connects_to database: { writing: :primary, reading: :primary }

  has_many :job_profile_skills
  has_many :job_profiles, through: :job_profile_skills, inverse_of: :skills

  def self.import(names)
    names.map { |name| find_or_create_by(name: name) }
  end
end
