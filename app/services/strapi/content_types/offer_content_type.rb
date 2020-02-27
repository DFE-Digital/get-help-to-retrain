module Strapi::ContentTypes
  class OfferContentType
    attr_reader :strapi_service

    def initialize(strapi_service: Strapi::StrapiService.new)
      @strapi_service = strapi_service
      @standard_component_renderer = Strapi::Components::StandardComponentRenderer.new(link_attributes: {:class => 'govuk-link'})
      @telephone_component_renderer = Strapi::Components::StandardComponentRenderer.new(link_attributes: {:class => 'govuk-link'})
    end

    def content()
      json = @strapi_service.content('offers/1')
      json['standard'] = @strapi_service.render(json['Standard'][0], @standard_component_renderer)
      json['telephone'] = @strapi_service.render(json['Telephone'][0], @telephone_component_renderer)
      json
    end
  end
end
