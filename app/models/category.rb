class Category < ApplicationRecord
  has_many :job_profile_categories
  has_many :job_profiles, through: :job_profile_categories, inverse_of: :categories
  scope :by_name, -> { order(:name) }

  def self.with_job_profiles
    includes(:job_profile_categories)
      .where
      .not(job_profile_categories: { job_profile_id: nil })
  end

  def self.with_job_profiles_without(category)
    Category
      .with_job_profiles
      .by_name
      .where.not(id: category)
  end

  def self.import(slug, url)
    find_or_create_by(slug: slug) do |category|
      category.update(source_url: url, name: slug.titleize)
    end
  end
end
