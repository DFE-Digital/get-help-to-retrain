class Session < RestrictedActiveRecordBase
  has_one :user

  validate :health_checkpoint

  private

  def health_checkpoint
    return if data.present? && data['request_path'].exclude?('/status_check')

    errors.add(:data, 'Health checkpoint hit')
  end
end
