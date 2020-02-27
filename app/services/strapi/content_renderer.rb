require 'redcarpet'

module Strapi

  class ContentRenderer < Redcarpet::Render::HTML

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
