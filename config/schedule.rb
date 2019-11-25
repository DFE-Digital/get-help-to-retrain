# set :output, error: 'log/error.log', standard: 'log/standard.log'

every 1.minute do
  rake 'scheduled_task:log'
end
