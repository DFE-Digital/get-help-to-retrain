class JobProfileSearch
  include ActiveModel::Validations

  attr_reader :term
  validates :term, presence: { message: I18n.t('job_profiles_search.no_term_error') }

  def initialize(term:)
    @term = term
  end

  def search
    return JobProfile.none unless valid?

    JobProfile
      .select(:id, :name, :description, :alternative_titles, :slug, :salary_min, :salary_max)
      .where(build_text_search_query, query_string: query_string)
      .order(
        Arel.sql(build_rank_query) => :desc
      )
  end

  private

  def build_text_search_query
    <<-SQL
      to_tsvector('english', name) @@ to_tsquery('english', :query_string)
      OR to_tsvector('english', alternative_titles) @@ to_tsquery('english', :query_string)
      OR to_tsvector('english', description) @@ to_tsquery('english', :query_string)
    SQL
  end

  def build_rank_query
    quoted_query_string = ActiveRecord::Base.connection.quote(query_string)

    <<-RANK
      ts_rank(to_tsvector('english', name), to_tsquery('english', #{quoted_query_string}))
    RANK
  end

  def query_string
    @query_string ||= QueryStringFormatter.format(term)
  end
end
