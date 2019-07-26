namespace :data_import do
  # bin/rails data_import:sample_courses
  desc 'Populate sample courses data'
  task sample_courses: :environment do
    print 'Populating sample courses data'
    CoursesService.new.seed!
  end
end
