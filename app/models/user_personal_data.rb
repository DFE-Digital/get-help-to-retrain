class UserPersonalData < RestrictedActiveRecordBase
  attr_accessor :birth_day, :birth_month, :birth_year

  enum gender: { female: 'female', male: 'male', not_mentioned: 'prefer not to say' }

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :postcode, presence: true
  validates :postcode, postcode: true, allow_blank: true
  validate  :dob_format
  validate  :dob_in_the_past, if: -> { dob.present? }
  validates :gender, presence: true

  has_paper_trail on: %i[update]

  private

  def dob_format
    handle_format_errors_for(birth_day, birth_month, birth_year)
  rescue ArgumentError
    add_error_message(key: 'dob.invalid')
  end

  def add_error_message(key:)
    errors.add(:dob, I18n.t(key, scope: 'activerecord.errors.models.user_personal_data.attributes'))
  end

  def dob_in_the_past
    add_error_message(key: 'dob.past') if dob > DateTime.now
    add_error_message(key: 'dob.invalid') if dob < Date.new(1900, 1, 1)
  end

  # Because there 8 possible combinations given by birth_day, birth_month and birth_year,
  # we are using the following truth table:
  #
  # birth_day birth_month birth_year | encoded_date
  # 0         0           0          | 0
  # 0         0           1          | 1
  # 0         1           0          | 2
  # .................................| ..
  # where: 0 = missing or negative value, 1 - value present and positive
  # This way we can use the encoded date of birth and capture every possible combination so we can
  # display the correct date format error message.

  def handle_format_errors_for(birth_day, birth_month, birth_year) # rubocop:disable Metrics/CyclomaticComplexity
    case encode_date(birth_day, birth_month, birth_year)
    when 0 then add_error_message(key: 'dob.blank')
    when 1 then add_error_message(key: 'dob.missing_day_month')
    when 2 then add_error_message(key: 'dob.missing_day_year')
    when 3 then add_error_message(key: 'dob.missing_day')
    when 4 then add_error_message(key: 'dob.missing_month_year')
    when 5 then add_error_message(key: 'dob.missing_month')
    when 6 then add_error_message(key: 'dob.missing_year')
    else self.dob = Date.new(birth_year.to_i, birth_month.to_i, birth_day.to_i)
    end
  end

  def encode_date(birth_day, birth_month, birth_year)
    [birth_day, birth_month, birth_year].map { |e| to_binary(e) }.join('').to_i(2)
  end

  def to_binary(value)
    value.to_i.positive? ? 1 : 0
  end
end
