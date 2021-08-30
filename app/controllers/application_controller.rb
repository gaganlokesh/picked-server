class ApplicationController < ActionController::API
  before_action :doorkeeper_authorize!

  def not_authorized
    render json: { message: "Unauthorized Request" }, status: :unauthorized
  end

  def current_user
    return current_resource_owner if doorkeeper_token
  end

  private

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
