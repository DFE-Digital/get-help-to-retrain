class SpellCheckService
  SpellCheckServiceError = Class.new(StandardError)

  API_ENDPOINT = 'https://api.cognitive.microsoft.com/bing/v7.0/spellcheck'.freeze

  attr_reader :response

  def initialize(api_key: Rails.configuration.bing_spell_check_api_key)
    @api_key = api_key
  end

  def scan(search_term: nil)
    return unless search_term

    bing_spell_check(search_term: search_term)
  rescue StandardError => e
    Rails.logger.error("Spell Check service error: #{e.message}")
    raise SpellCheckServiceError, e.message
  end

  private

  def bing_spell_check(search_term: nil)
    uri.query = URI.encode_www_form(mkt: 'en-gb', mode: 'spell', text: search_term)

    @response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') { |http|
      http.request(request)
    }

    return suggested_correction(search_term) if response_successful?

    handle_api_errors
  end

  def suggested_correction(search_term)
    return unless bing_correction.present?

    search_term.downcase.split(' ').map { |word|
      bing_correction.key?(word) ? bing_correction[word] : word
    }.uniq.join(' ')
  end

  def bing_correction
    @bing_correction ||= JSON.parse(response.body)['flaggedTokens'].each_with_object({}) do |token, hash|
      hash[token['token']] = token['suggestions'].first['suggestion']
    end
  end

  def api_key
    raise 'BingSpellCheck API Key is not set' unless @api_key.present?

    @api_key
  end

  def response_successful?
    response.is_a? Net::HTTPSuccess
  end

  def uri
    @uri ||= URI.parse(API_ENDPOINT)
  end

  def request
    request = Net::HTTP::Get.new(uri.request_uri)
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    request['Ocp-Apim-Subscription-Key'] = api_key

    request
  end

  def handle_api_errors
    Rails.logger.error("Bing Spell Check API error: #{response.body}, code: #{response.code}")

    raise SpellCheckServiceError, "Code: #{response.code}, response: #{response.body}"
  end
end
