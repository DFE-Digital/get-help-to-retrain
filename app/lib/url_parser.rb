class UrlParser
  attr_reader :uri, :host, :original

  def initialize(referer, host, original = nil)
    @uri = URI(referer) if referer
    @host = host
    @original = URI(original) if original
  end

  def get_redirect_path(paths_to_ignore: [])
    return unless recognized_host?
    return if paths_to_ignore.include?(uri.path) || referred_from_same_page?

    uri.request_uri
  end

  private

  def recognized_host?
    return unless uri

    uri.host == host
  rescue ArgumentError, URI::Error
    false
  end

  def referred_from_same_page?
    return unless original

    original.path == uri.path
  end
end
