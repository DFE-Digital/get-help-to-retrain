module Strapi::ContentTypes
  class BaseContentType
    attr_reader :strapi_service

    def initialize(strapi_service = Strapi::StrapiService.new)
      @strapi_service = strapi_service
      @renderer = Strapi::Renderer.new(link_attributes: {:class => 'govuk-link'})
    end
  end
end
