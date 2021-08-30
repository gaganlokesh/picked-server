class UsersController < ApplicationController
  skip_before_action :doorkeeper_authorize!, only: [:show]

  def show
    user = User.find(params[:id])
    render json: UserBlueprint.render(user), status: :ok
  end

  def me
    render json: UserBlueprint.render(current_user), status: :ok
  end
end
