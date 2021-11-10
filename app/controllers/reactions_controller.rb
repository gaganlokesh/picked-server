class ReactionsController < ApplicationController
  def create
    reaction = Reaction.new(
      reactable_type: params[:reactable_type],
      reactable_id: params[:id],
      user_id: current_user.id
    )

    if reaction.save
      render json: { status: "success", message: "Reaction added!" }, status: :created
    else
      render json: { status: "error", message: "Reaction could not be added" }, status: :unprocessable_entity
    end
  end

  def destroy
    reaction = Reaction.find_by(
      reactable_type: params[:reactable_type],
      reactable_id: params[:id],
      user_id: current_user.id
    )

    if reaction.destroy
      render json: { status: "success", message: "Reaction removed!" }, status: :ok
    else
      render json: { status: "error", message: "Reaction could not be removed" }, status: :unprocessable_entity
    end
  end
end
