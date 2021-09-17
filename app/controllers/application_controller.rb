class ApplicationController < ActionController::API
  before_action :doorkeeper_authorize!

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  rescue_from ActiveRecord::RecordInvalid do |e|
    unprocessable_entity(e.message)
  end

  def not_authorized
    render json: { status: 401, error: "Unauthorized Request" }, status: :unauthorized
  end

  def not_found
    render json: { status: 404, error: "Not Found" }, status: :not_found
  end

  def unprocessable_entity(message)
    render json: { status: 422, error: message }, status: :unprocessable_entity
  end

  # Custom doorkeeper authorization error response
  def doorkeeper_unauthorized_render_options(*)
    { json: { status: 401, error: "Unauthorized Request" } }
  end

  def current_user
    return current_resource_owner if doorkeeper_token
  end

  private

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
