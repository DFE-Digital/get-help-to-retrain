class StatusCheckController < ApplicationController
  def index
    render json: { message: 'Pong', status: 200 }
  end
end
