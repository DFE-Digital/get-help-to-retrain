module Strapi::ContentTypes
  class OfferContentType < Strapi::ContentTypes::BaseContentType

    def content()
      offer_hash = @strapi_service.content_as_hash('offers/1')

      content_hash = offer_hash['Standard'][0]
      content_hash['body'] = @renderer.render_markdown(content_hash['body'])
      content_hash['tel'] = offer_hash['Tel'][0]

      rendered = @renderer.render_component("standard_component.erb", content_hash)
      rendered
    end
  end
end
