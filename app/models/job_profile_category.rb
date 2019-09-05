class JobProfileCategory < ApplicationRecord
  connects_to database: { writing: :primary, reading: :primary }

  belongs_to :job_profile
  belongs_to :category
end
