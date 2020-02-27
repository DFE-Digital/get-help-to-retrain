require 'redcarpet'

module Strapi

  class Renderer < Redcarpet::Render::HTML

    def render_component(component_name, content)
      file_path = "#{Dir.getwd}/public/components/#{component_name}"
      @template = File.open(file_path, 'rb', &:read)
      ERB.new(@template).result(binding)
    end

    def render_markdown(md)
      markdown = Redcarpet::Markdown.new(self, extensions = {})
      markdown.render(md)
    end

    def paragraph(text)
      %(<p class="govuk-body-m">#{text}</p>
  )
    end

    def header(title, level)
      case level
      when 1
        %(<h1 class="class="govuk-heading-s">#{title}</h1>
  )
      when 2
        %(<h2 class="class="govuk-heading-s">#{title}</h2>
  )
      end
    end

    def list(content, list_type)
      case list_type
      when :ordered
        %(<ol class="govuk-list govuk-list--bullet">
  #{content}</ol>)
      when :unordered
        %(<ul class="govuk-list govuk-list--bullet">
  #{content}</ul>)
      end
    end
  end
end
