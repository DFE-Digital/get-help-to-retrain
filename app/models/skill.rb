class Skill < ApplicationRecord
  belongs_to :version
  has_many :job_profile_skills, dependent: :delete_all
  has_many :job_profiles, through: :job_profile_skills, inverse_of: :skills
end
