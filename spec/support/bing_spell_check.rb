module BingSpellCheck
  def fake_bing_api_call_with(response_body, text)
    request_headers = {
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Ocp-Apim-Subscription-Key' => 'test'
    }

    stub_request(:get, Rails.configuration.bing_spell_check_api_endpoint)
      .with(headers: request_headers,
            query: URI.encode_www_form(mkt: 'en-gb', mode: 'spell', text: text))
      .to_return(body: response_body, status: 200)
  end

  def stub_bing_api_keys
    allow(Rails.configuration).to receive(:bing_spell_check_api_endpoint).and_return('https://s111-bingspellcheck.cognitiveservices.azure.com/bing/v7.0/spellcheck')
    allow(Rails.configuration).to receive(:bing_spell_check_api_key).and_return('test')
  end
end

RSpec.configure do |config|
  config.include BingSpellCheck
end
