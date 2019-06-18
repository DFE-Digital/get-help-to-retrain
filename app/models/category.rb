class Category < ApplicationRecord
  has_many :job_profile_categories
  has_many :job_profiles, through: :job_profile_categories, inverse_of: :categories

  def self.with_job_profiles
    includes(:job_profile_categories)
      .where.not(job_profile_categories: { job_profile_id: nil })
  end
end
