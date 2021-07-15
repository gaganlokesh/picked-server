class ApplicationController < ActionController::API
  before_action :doorkeeper_authorize!

  def not_authorized
    render json: { message: "Unauthorized Request" }, status: :unauthorized
  end
end
