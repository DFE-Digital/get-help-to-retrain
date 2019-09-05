class RestrictedActiveRecordBase < ActiveRecord::Base
  self.abstract_class = true

  connects_to database: { writing: :restricted, reading: :restricted }
end
