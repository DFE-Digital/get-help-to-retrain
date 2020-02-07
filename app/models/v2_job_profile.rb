class V2JobProfile < PrimaryActiveRecordBase
  has_many :v2_job_profile_skills
  has_many :v2_skills, through: :v2_job_profile_skills, inverse_of: :v2_job_profiles

  scope :recommended, -> { where(recommended: true) }
  scope :excluded, -> { where(recommended: false) }

  has_paper_trail

  def self.find_by_name(name)
    where('lower(name) = ?', name.downcase).first
  end

  def skills
    v2_skills
  end

  def with_skills(skill_ids)
    {
      profile_id: id,
      profile_slug: slug,
      name: name,
      skills: skills.each_with_object({}) { |skill, hash| hash[skill.id] = skill.name }
                    .slice(*skill_ids)
    }
  end
end
