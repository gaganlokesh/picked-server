class UsersController < ApplicationController
  skip_before_action :doorkeeper_authorize!, only: [:show]

  def show
    user = User.find(params[:id])
    render json: UserBlueprint.render(user), status: :ok
  end

  def update
    if current_user.update(user_params)
      render json: UserBlueprint.render(current_user), status: :ok
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

  def me
    render json: UserBlueprint.render(current_user, view: :me), status: :ok
  end

  def dismiss_action
    if params[:action].present?
      dismissed_actions = current_user.dismissed_actions.push(params[:action])
      current_user.update(dismissed_actions: dismissed_actions)

      render json: { dismissed_actions: current_user.dismissed_actions }, status: :ok
    else
      render json: { status: "error", message: "Action is required" }, status: :unprocessable_entity
    end
  end

  def validate_username
    username = params[:username]&.downcase
    errors = User.new(username: username).validate_attribute(:username)

    if errors.blank?
      render json: { valid: true }, status: :ok
    else
      render json: { valid: false, message: "Username #{errors.first}" }, status: :ok
    end
  end

  private

  def user_params
    params.permit(:id, :name, :username, :email)
  end
end
