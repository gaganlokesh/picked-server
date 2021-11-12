class ViewsController < ApplicationController
  skip_before_action :doorkeeper_authorize!

  def create
    view = if current_user.present?
             View.find_or_initialize_by(user_id: current_user.id, article_id: params[:id])
           else
             View.new(article_id: params[:id])
           end

    unless view.new_record?
      view.increment(:count)
    end
    view.save

    head :ok
  end
end
