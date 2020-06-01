class StatusReport
  STATUS_CODES = {
    pass: 200,
    warn: 200,
    fail: 503
  }.freeze

  def initialize(app)
    @app = app
  end

  def call(env) # rubocop:disable Metrics/MethodLength
    if ActionDispatch::Request::HTTP_METHODS.exclude?(env['REQUEST_METHOD'].upcase)
      [405, { 'Content-Type' => 'text/plain' }, ['Method Not Allowed']]
    elsif env['PATH_INFO'] == '/status'
      health = HealthCheck::ReportService.new
      [
        STATUS_CODES[health.status],
        { 'Content-Type' => 'application/health+json; charset=utf-8' },
        [health.report.to_json]
      ]
    else
      @app.call(env)
    end
  end
end
