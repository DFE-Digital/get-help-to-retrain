class UrlParser
  attr_reader :uri, :host

  def initialize(referer, host)
    @uri = URI(referer) if referer
    @host = host
  end

  def build_redirect_url_with(params:, anchor:)
    return unless recognized_host?

    uri.query = Rack::Utils.build_query(params)
    uri.fragment = anchor
    uri.to_s
  end

  def get_redirect_path(paths_to_ignore: [])
    return unless recognized_host?
    return if paths_to_ignore.include?(uri.path)

    uri.request_uri
  end

  private

  def recognized_host?
    return unless uri

    uri.host == host
  rescue ArgumentError, URI::Error
    false
  end
end
