class JobProfileCategory < ApplicationRecord
  belongs_to :job_profile
  belongs_to :category
end
