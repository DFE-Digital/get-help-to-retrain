module Content::ContentTypes
  class BaseContentType
    attr_reader :content_service

    def initialize(content_service = Content::StrapiService.new)
      @content_service = content_service
      @renderer = Content::Renderer.new(link_attributes: {:class => 'govuk-link'})
    end
  end
end
