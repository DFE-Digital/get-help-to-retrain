class TestJob < ApplicationJob
  queue_as :test_queue

  before_enqueue do
    throw(:abort) if already_enqueued?
  end

  after_perform do
    TestJob.delay(run_at: 1.minute.from_now).perform_later
  end

  def already_enqueued?
    Delayed::Job.where(queue: 'test_queue', locked_at: nil, failed_at: nil, attempts: 0).any?
  end

  def perform
    puts 'Scheduled task running ...'
  end
end
