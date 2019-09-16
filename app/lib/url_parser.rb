class UrlParser
  attr_reader :uri, :host

  def initialize(referer, host)
    @uri = URI(referer)
    @host = host
  end

  def build_redirect_url_with(param_name:, param_value:, anchor:)
    return unless recognized_host?

    query = Rack::Utils.parse_query(uri.query)
    query[param_name] = param_value
    uri.query = Rack::Utils.build_query(query)
    uri.fragment = anchor
    uri.to_s
  end

  def get_redirect_path(paths_to_ignore: [])
    return if paths_to_ignore.include?(uri.path)
    return unless recognized_host?

    uri.request_uri
  end

  private

  def recognized_host?
    uri.host == host
  rescue ArgumentError, URI::Error
    false
  end
end
