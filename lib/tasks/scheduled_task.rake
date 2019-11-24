desc 'Log scheduled task'
namespace :scheduled_task do
  task log: :environment do
    TestJob.perform_later
  end
end
