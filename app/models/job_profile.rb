class JobProfile < ApplicationRecord
  has_many :categories, through: :job_profile_categories
  has_many :skills, through: :job_profile_skills
end
