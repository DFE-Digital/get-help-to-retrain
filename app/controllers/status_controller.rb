class StatusController < ApplicationController
  layout false

  STATUS_CODES = {
    pass: :ok,
    warn: :multi_status,
    fail: :service_unavailable
  }.freeze

  def index
    health = HealthCheck::ReportService.new

    render json: health.report.to_json,
           status: STATUS_CODES[health.status],
           content_type: 'application/health+json'
  end
end
