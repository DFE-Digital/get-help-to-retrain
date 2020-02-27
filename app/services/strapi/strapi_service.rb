require 'redcarpet'

module Strapi
  class StrapiService
    attr_reader :authorization

    API_ENDPOINT = 'http://localhost:1337/'.freeze
    ResponseError = Class.new(StandardError)
    APIError = Class.new(StandardError)

    def initialize(
      authorization: Rails.configuration.strapi_authorization
    )
      @authorization = authorization
    end

    def render(json, renderer = Strapi::Renderer.new(link_attributes: {:class => 'govuk-link'}))
      markdown = Redcarpet::Markdown.new(renderer, extensions = {})
      markdown.render(json)
    end

    def content_as_hash(path)
      JSON.parse(content(path))
    end

    def content(path)
      return {} unless authorization
      uri = build_uri(path: path, options: {})
      response_body(uri)
    end

    def health_check
      uri = build_uri(path: 'ping')
      JSON.parse(response_body(uri))
    end

    private

    def response_body(uri)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', read_timeout: 5) do |http|
        request = Net::HTTP::Get.new(uri)
        request['Content-Type'] = 'application/json; charset=UTF-8'
        # request['Authorization'] = authorization
        response = http.request(request)
        raise ResponseError, "#{response.code} - #{response.message}" unless response.is_a?(Net::HTTPSuccess)

        response.body
      end
    rescue StandardError => e
      Rails.logger.error("Strapi Service API error: #{e.inspect}")
      raise APIError, e
    end

    def build_uri(path:, options: {})
      build_uri = URI.join(API_ENDPOINT, path)
      # build_uri.query = URI.encode_www_form(query_values(options))
      build_uri
    end

    def query_values(options)
      {
        authorization: authorization,
      }.reject { |_k, v| v.blank? }
    end
  end
end
