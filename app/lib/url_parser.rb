class UrlParser
  attr_reader :uri, :host

  def initialize(referer, host)
    @uri = URI(referer) if referer
    @host = host
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
