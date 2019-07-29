module FormHelper
  def form_group_tag(object, attribute, &_block)
    css_classes = ['govuk-form-group']
    css_classes << 'govuk-form-group--error' if object.errors.key?(attribute)
    content_tag(:div, class: css_classes) do
      yield
    end
  end

  def errors_tag(object, attribute)
    return unless object.errors.messages[attribute].present?

    content_tag(
      :span,
      messages(object, attribute).join('<br>').html_safe,
      class: 'govuk-error-message',
      id: error_id(object.class.model_name.singular, attribute)
    )
  end

  def css_classes_for_input(object, attribute, css_classes = '')
    css_classes = css_classes.split
    css_classes << 'govuk-input'
    css_classes << 'govuk-input--error' if object.errors.key?(attribute)
    css_classes.join(' ')
  end

  private

  def error_id(object_name, attribute)
    "#{object_name}_#{attribute}-error"
  end

  def messages(object, attribute)
    object.errors.messages[attribute].map { |message|
      content_tag(:span, 'Error:', class: 'govuk-visually-hidden') + ' ' + message
    }
  end
end
