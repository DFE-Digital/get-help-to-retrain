class JobProfileSkill < ApplicationRecord
  belongs_to :job_profile
  belongs_to :skill
end
