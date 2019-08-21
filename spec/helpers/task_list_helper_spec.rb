require 'rails_helper'

RSpec.describe TaskListHelper do
  describe '#link_or_blocked' do
    it 'wraps the supplied block in a link tag if enabled' do
      block_html = ('some text' + content_tag(:span, 'other text')).html_safe
      expected_classes = 'govuk-link govuk-body govuk-!-margin-bottom-4 govuk-!-margin-top-0'

      expect(helper.link_or_blocked(path: 'some-path', enabled: true, span_id: 1) { block_html }).to eq(
        <<~HTML.strip
          <a class="#{expected_classes}" href="some-path">some text<span>other text</span></a>
        HTML
      )
    end

    it 'allows extra link options to be added' do
      expected_classes = 'govuk-link govuk-body govuk-!-margin-bottom-4 govuk-!-margin-top-0'

      expect(
        helper.link_or_blocked(
          path: 'some-path',
          enabled: true,
          span_id: 1,
          data: { tracked_event: 'task' },
          target: '_blank'
        ) { 'some text' }
      ).to eq(
        <<~HTML.strip
          <a class="#{expected_classes}" data-tracked-event="task" target="_blank" href="some-path">some text</a>
        HTML
      )
    end

    it 'adds a cannot start yet section and wraps block in body tag when disabled' do
      expected_classes = 'govuk-!-margin-bottom-4 govuk-!-margin-top-0'

      expect(helper.link_or_blocked(path: '/some-path', enabled: false, span_id: 1) { 'some text' }).to eq(
        <<~HTML.strip
          <span class="govuk-tag app-task-list__task-not-active" id="section-1-blocked">Can't start yet</span>\
          <p class="#{expected_classes}">some text</p>
        HTML
      )
    end
  end
end
