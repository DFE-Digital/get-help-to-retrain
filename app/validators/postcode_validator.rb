class PostcodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value

    uk_postcode = UKPostcode.parse(value)
    record.errors[attribute] << I18n.t('courses.invalid_postcode_error') unless uk_postcode.full_valid?
  end
end
