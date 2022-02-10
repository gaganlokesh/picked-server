class UsersController < ApplicationController
  skip_before_action :doorkeeper_authorize!, only: [:show]

  def show
    user = User.find(params[:id])
    render json: UserBlueprint.render(user), status: :ok
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
end
