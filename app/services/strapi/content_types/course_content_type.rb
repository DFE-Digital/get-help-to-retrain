module Strapi::ContentTypes
  class CourseContentType
    attr_reader :strapi_service

    def initialize(strapi_service = Strapi::StrapiService.new)
      @strapi_service = strapi_service
    end

    def content()
      json = @strapi_service.content_as_hash('courses/1')
      json['no_results'] = @strapi_service.render(json['no_results'])
      json
    end
  end
end
