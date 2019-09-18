class StatusCheckController < ApplicationController
  def index
    request.session_options[:skip] = true

    render json: { message: 'Pong', status: 200 }
  end
end
