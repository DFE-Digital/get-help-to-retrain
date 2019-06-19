class Category < ApplicationRecord
  belongs_to :version
  has_many :job_profile_categories, dependent: :delete_all
  has_many :job_profiles, through: :job_profile_categories, inverse_of: :categories
end
