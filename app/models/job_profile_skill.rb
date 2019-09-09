class JobProfileSkill < PrimaryActiveRecordBase
  belongs_to :job_profile
  belongs_to :skill
end
