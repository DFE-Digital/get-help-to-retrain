class UserPersonalData < RestrictedActiveRecordBase
  attr_accessor :birth_day, :birth_month, :birth_year

  enum gender: { female: 'female', male: 'male', not_mentioned: 'prefer not to say' }

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :postcode, presence: true
  validates :postcode, postcode: true, allow_blank: true
  validate  :dob_format
  validate  :dob_in_the_past, if: -> { dob? }
  validates :gender, presence: true

  private

  def dob_format
    self.dob = Date.new(birth_year.to_i, birth_month.to_i, birth_day.to_i)
  rescue ArgumentError
    add_invalid_dob_error
  end

  def dob_in_the_past
    add_invalid_dob_error if dob > DateTime.now
  end

  def add_invalid_dob_error
    errors.add(:dob, I18n.t('dob.invalid', scope: 'activerecord.errors.models.user_personal_data.attributes'))
  end
end
