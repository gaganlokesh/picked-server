class BookmarksController < ApplicationController
  PER_PAGE = 15

  def index
    per_page = params[:per_page] || PER_PAGE
    articles = current_user.bookmarked_articles
      .includes(:source, :bookmarks)
      .page(params[:page].to_i)
      .per(per_page)

    render json: ArticleBlueprint.render(
      articles,
      current_user: current_user,
      view: :with_user_context
    ), status: :ok
  end
end
