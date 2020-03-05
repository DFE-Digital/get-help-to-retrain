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

    JobProfile.select(:id, :name, :description, :alternative_titles, :slug, :salary_min, :salary_max, :growth, "#{build_rank_query} as rank", "#{build_rank_query2} as rank2")
              .where(build_text_search_query, query_string: query_string)
              .where.not(id: profile_ids_to_exclude)
              .order(rank: :desc, rank2: :asc, name: :asc)
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

  def build_rank_query2
    build_hrank_query
  end

  def build_rank_query
    (exact_match_ranking + partial_match_ranking + sector)
      .join(" +\n")
  end

  def quoted_query
    @quoted_query ||= PrimaryActiveRecordBase.connection.quote(query_string)
  end

  def build_hrank_query
    (hrank)
      .join(" +\n")
  end

  def hrank
    {
      heirarchy: { weight: 'A', score: 0 },
      name: { weight: 'A', score: 2 }
    }.map do |column, values|
      vector_rank(match: 'simple', column: column, weight: values[:weight], score: values[:score])
    end
  end

  def exact_match_ranking
    {
      name: { weight: 'A', score: 2 },
      alternative_titles: { weight: 'AB', score: 8 },
      specialism: { weight: 'ABC', score: 2 },
      hidden_titles: { weight: 'ABC', score: 2 },
      description: { weight: 'ABCD', score: 2 }
    }.map do |column, values|
      vector_rank2(match: 'simple', column: column, weight: values[:weight], score: values[:score])
    end
  end

  def partial_match_ranking
    {
      name: { weight: 'A', score: 2 },
      alternative_titles: { weight: 'B', score: 8 },
      specialism: { weight: 'C', score: 2 },
      hidden_titles: { weight: 'C', score: 2 },
      description: { weight: 'D', score: 2 }
    }.map do |column, values|
      vector_rank(match: 'english', column: column, weight: values[:weight], score: values[:score])
    end
  end

  def sector
    {
      sector: { weight: 'A', score: 0},
      name: { weight: 'A', score: 0},
      alternative_titles: { weight: 'B', score: 8 },
      description: { weight: 'D', score: 2 }
    }.map do |column, values|
      vector_rank(match: 'english', column: column, weight: values[:weight], score: values[:score])
    end
  end

  def vector_rank(match:, column:, weight:, score:)
    <<-RANK
      COALESCE(
        ts_rank(
          setweight(
            to_tsvector('#{match}', #{column}),
            '#{weight}'
          ),
          to_tsquery('#{match}', #{quoted_query}),
          #{score}
        ),
        0
      )
    RANK
  end

  def vector_rank2(match:, column:, weight:, score:)
    <<-RANK
      COALESCE(
        ts_rank(
          setweight(
            to_tsvector('#{match}', #{column}),
            '#{weight}'
          ),
          to_tsquery('#{match}', #{PrimaryActiveRecordBase.connection.quote(term.gsub(' ', ' & '))}),
          #{score}
        ),
        0
      )
    RANK
  end

  def query_string
    @query_string ||= QueryStringFormatter.format(term)
  end
end
