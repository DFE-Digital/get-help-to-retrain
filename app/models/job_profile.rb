class JobProfile < ApplicationRecord
  has_many :job_profile_categories
  has_many :job_profile_skills
  has_many :categories, through: :job_profile_categories, inverse_of: :job_profiles
  has_many :skills, through: :job_profile_skills, inverse_of: :job_profiles

  has_and_belongs_to_many :related_job_profiles,
                          class_name: 'JobProfile',
                          join_table: :related_job_profiles,
                          foreign_key: :job_profile_id,
                          association_foreign_key: :related_job_profile_id

  scope :recommended, -> { where(recommended: true) }
  scope :excluded, -> { where(recommended: false) }

  def self.find_by_name(name)
    where('lower(name) = ?', name.downcase).first
  end

  def self.search(string)
    return none unless string.present?

    query_string = QueryStringFormatter.format(string)

    select(:id, :name, :description, :alternative_titles, :slug, :salary_min, :salary_max)
      .where(build_text_search_query, query_string: query_string)
      .order(
        Arel.sql(build_rank_query(query_string)) => :desc
      )
  end

  def self.build_text_search_query
    <<-SQL
      to_tsvector('english', name) @@ to_tsquery('english', :query_string)
      OR to_tsvector('english', alternative_titles) @@ to_tsquery('english', :query_string)
      OR to_tsvector('english', description) @@ to_tsquery('english', :query_string)
    SQL
  end

  def self.build_rank_query(query_string)
    quoted_query_string = ActiveRecord::Base.connection.quote(query_string)

    <<-RANK
      ts_rank(to_tsvector('english', name), to_tsquery('english', #{quoted_query_string}))
    RANK
  end

  def self.import(slug, url)
    find_or_create_by(slug: slug) do |job_profile|
      job_profile.update(source_url: url, name: slug.titleize)
    end
  end

  def scrape(scraper = JobProfileScraper.new)
    scraped = scraper.scrape(source_url)

    self.name = scraped.delete('title')
    self.skills = Skill.import scraped.delete('skills')
    self.related_job_profiles = JobProfile.where(slug: scraped.delete('related_profiles') - [slug])

    update!(scraped)
  end
end
