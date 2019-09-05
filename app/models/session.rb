class Session < ApplicationRecord
  connects_to database: { writing: :restricted, reading: :restricted }
end
