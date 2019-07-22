class PostcodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value

    uk_postcode = UKPostcode.parse(value)
    record.errors[attribute] << 'Invalid UK postcode' unless uk_postcode.full_valid?
  end
end
