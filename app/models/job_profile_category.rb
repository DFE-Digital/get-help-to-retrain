class JobProfileCategory < PrimaryActiveRecordBase
  belongs_to :job_profile
  belongs_to :category
end
