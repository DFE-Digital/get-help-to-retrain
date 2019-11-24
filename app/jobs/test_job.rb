class TestJob < ApplicationJob
  queue_as :default

  # after_perform do
  #   TestJob.delay(run_at: 30.seconds.from_now).perform_later
  # end

  def perform
    puts 'Scheduled task running ...'
  end
end
