module TaskListHelper
  def link_or_blocked(path, enabled, span_id, **options, &block)
    if enabled
      classes = 'govuk-link govuk-body govuk-!-margin-bottom-4 govuk-!-margin-top-0'
      link_to(path, class: classes, data: options[:data], target: options[:target]) do
        yield
      end
    else
      blocked_section(span_id, &block)
    end
  end

  private

  def blocked_section(span_id, &_block)
    content_tag(
      :span,
      "Can't start yet".html_safe,
      class: 'govuk-tag app-task-list__task-not-active',
      id: "section-#{span_id}-blocked"
    ) + content_tag(:p, class: 'govuk-!-margin-bottom-4 govuk-!-margin-top-0') { yield }
  end
end
