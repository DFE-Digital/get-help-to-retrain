class Skill < ApplicationRecord
  has_many :job_profiles, through: :job_profile_skills
end
