namespace :data_import do
  # bin/rails data_import:sample_admin_data
  desc 'Populate sample data for admin area'
  task sample_admin_data: :environment do
    print 'Populating sample feedback surveys'
    10.times { FactoryBot.create :feedback_survey, :with_message }

    print 'Populating sample user personal data'
    10.times { FactoryBot.create :user_personal_data }
  end
end
