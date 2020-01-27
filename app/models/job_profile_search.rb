class JobProfileSearch
  include ActiveModel::Validations

  attr_reader :term, :profile_ids_to_exclude
  validates :term, presence: { message: I18n.t('job_profiles_search.no_term_error') }

  def initialize(term:, profile_ids_to_exclude: [])
    @term = term
    @profile_ids_to_exclude = profile_ids_to_exclude
  end

  def search
    return JobProfile.none unless valid?

    JobProfile.select(:id, :name, :description, :alternative_titles, :slug, :salary_min, :salary_max, :growth)
              .where(build_text_search_query, query_string: query_string)
              .where.not(id: profile_ids_to_exclude)
              .order(Arel.sql(build_rank_query) => :desc, name: :asc)
  end

  private

  def build_text_search_query
    <<-SQL
      to_tsvector('english', name) @@ to_tsquery('english', :query_string)
      OR to_tsvector('english', alternative_titles) @@ to_tsquery('english', :query_string)
      OR to_tsvector('english', specialism) @@ to_tsquery('english', :query_string)
      OR to_tsvector('english', hidden_titles) @@ to_tsquery('english', :query_string)
      OR to_tsvector('english', description) @@ to_tsquery('english', :query_string)
    SQL
  end

  def build_rank_query
    (exact_match_ranking + partial_match_ranking)
      .join(" +\n")
  end

  def quoted_query
    @quoted_query ||= PrimaryActiveRecordBase.connection.quote(query_string)
  end

  def exact_match_ranking
    {
      name: 'A',
      alternative_titles: 'AB',
      specialism: 'ABC',
      hidden_titles: 'ABC',
      description: 'ABCD'
    }.map do |column, weight|
      vector_rank(match: 'simple', column: column, weight: weight)
    end
  end

  def partial_match_ranking
    {
      name: 'A',
      alternative_titles: 'B',
      specialism: 'C',
      hidden_titles: 'C',
      description: 'D'
    }.map do |column, weight|
      vector_rank(match: 'english', column: column, weight: weight)
    end
  end

  def vector_rank(match:, column:, weight:)
    <<-RANK
      COALESCE(
        ts_rank(
          setweight(
            to_tsvector('#{match}', #{column}),
            '#{weight}'
          ),
          to_tsquery('#{match}', #{quoted_query})
        ),
        0
      )
    RANK
  end

  def query_string
    @query_string ||= QueryStringFormatter.format(term)
  end
end
