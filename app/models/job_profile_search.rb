class JobProfileSearch # rubocop:disable Metrics/ClassLength
  include ActiveModel::Validations

  EXACT_MATCH_RANK = {
    name: { weight: 'A', score: '4|1' },
    alternative_titles: { weight: 'AB', score: '4|32' },
    specialism: { weight: 'ABC', score: '4|1|32' },
    hidden_titles: { weight: 'ABC', score: '4|1|32' },
    description: { weight: 'ABCD', score: '4|8|32' }
  }.freeze

  PARTIAL_MATCH_RANK = {
    name: { weight: 'A', score: '0' },
    alternative_titles: { weight: 'B', score: '8|2' },
    specialism: { weight: 'C', score: '0' },
    hidden_titles: { weight: 'C', score: '0' },
    description: { weight: 'D', score: '4|8' },
    sector: { weight: 'A', score: '0' }
  }.freeze

  HIERARCHY_MATCH_RANK = {
    hierarchy: { weight: 'A', score: '0' }
  }.freeze

  attr_reader :term, :profile_ids_to_exclude
  validates :term, presence: { message: I18n.t('job_profiles_search.no_term_error') }

  def initialize(term:, profile_ids_to_exclude: [])
    @term = term
    @profile_ids_to_exclude = profile_ids_to_exclude
  end

  def search
    return JobProfile.none unless valid?

    JobProfile
      .select(:id, :name, :description, :alternative_titles, :slug, :salary_min, :salary_max, :growth)
      .where(build_text_search_query, query_string: query_string)
      .where.not(id: profile_ids_to_exclude)
      .order(ranks_query)
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

  def ranks_query
    {
      Arel.sql(build_exact_rank_query) => :desc,
      Arel.sql(build_partial_rank_query) => :desc,
      Arel.sql(build_hierarchy_rank_query) => :asc,
      name: :asc
    }
  end

  def build_exact_rank_query
    exact_match_ranking
      .join(" +\n")
  end

  def build_partial_rank_query
    partial_match_ranking(PARTIAL_MATCH_RANK)
      .join(" +\n")
  end

  def build_hierarchy_rank_query
    partial_match_ranking(HIERARCHY_MATCH_RANK)
      .join(" +\n")
  end

  def exact_match_ranking
    EXACT_MATCH_RANK.map do |column, values|
      vector_rank(
        match: 'simple',
        column: column,
        options: {
          weight: values[:weight], score: values[:score], query: quoted_exact_match_query
        }
      )
    end
  end

  def partial_match_ranking(ranks)
    ranks.map do |column, values|
      vector_rank(
        match: 'english',
        column: column,
        options: {
          weight: values[:weight], score: values[:score], query: quoted_query
        }
      )
    end
  end

  def vector_rank(match:, column:, options: {})
    <<-RANK
      COALESCE(
        ts_rank_cd(
          setweight(
            to_tsvector('#{match}', #{column}),
            '#{options[:weight]}'
          ),
          to_tsquery('#{match}', #{options[:query]}),
          #{options[:score]}
        ),
        0
      )
    RANK
  end

  def query_string
    @query_string ||= QueryStringFormatter.format(term)
  end

  def quoted_query
    PrimaryActiveRecordBase.connection.quote(query_string)
  end

  def exact_match_string
    QueryStringFormatter.format_exact_match(term)
  end

  def quoted_exact_match_query
    PrimaryActiveRecordBase.connection.quote(exact_match_string)
  end
end
