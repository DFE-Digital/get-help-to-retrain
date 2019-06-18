class Category < ApplicationRecord
  has_many :job_profile_categories
  has_many :job_profiles, through: :job_profile_categories, inverse_of: :categories
end
