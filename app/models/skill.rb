class Skill < ApplicationRecord
  has_many :job_profile_skills
  has_many :job_profiles, through: :job_profile_skills, inverse_of: :skills
end
