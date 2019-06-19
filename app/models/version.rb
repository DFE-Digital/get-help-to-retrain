class Version < ApplicationRecord
  enum version: [:draft, :current, :previous]

  has_many :skills, dependent: :delete_all
  has_many :categories, dependent: :delete_all
  has_many :job_profiles, dependent: :delete_all

  def self.draft
    @_draft ||= find_by(version: :draft)
  end

  def self.current
    @_current ||= find_by(version: :current)
  end

  def self.previous
    @_previous ||= find_by(version: :previous)
  end

  def self.promote
    previous&.delete
    current&.update(version: :previous)
    draft&.update(version: :current)
  end
end
