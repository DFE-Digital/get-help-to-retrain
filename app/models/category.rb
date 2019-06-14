class Category < ApplicationRecord
  has_many :job_profiles, through: :job_profile_categories
end
