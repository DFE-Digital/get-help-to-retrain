module Content::ContentTypes
  class CourseContentType < Content::ContentTypes::BaseContentType

    def content()
      content_hash = @content_service.content_as_hash('courses/1')
      content_hash['no_results'] = @renderer.render_markdown(content_hash['no_results'])
      content_hash
    end
  end
end
