class BookmarksController < ApplicationController
  PER_PAGE = 15

  def index
    per_page = params[:per_page] || PER_PAGE
    articles = current_user.bookmarked_articles
      .includes(:source)
      .page(params[:page].to_i)
      .per(per_page)

    render json: ArticleBlueprint.render(articles, current_user: current_user), status: :ok
  end
end
