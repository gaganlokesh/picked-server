class ApplicationController < ActionController::API
  def not_authorized
    render json: { message: "Unauthorized Request" }, status: :unauthorized
  end
end
