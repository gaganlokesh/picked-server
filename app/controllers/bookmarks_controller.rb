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

  def create
    article = Article.find(params[:id])
    bookmark = article.bookmarks.new(user: current_user)

    if bookmark.save
      render json: { status: "success", message: "Bookmark added!" }, status: :created
    else
      render json: { status: "error", message: "Bookmark could not be added" }, status: :unprocessable_entity
    end
  end

  def destroy
    article = Article.find(params[:id])
    bookmark = article.bookmarks.find_by(user: current_user)

    if bookmark.destroy
      render json: { status: "success", message: "Bookmark removed!" }, status: :ok
    else
      render json: { status: "error", message: "Bookmark could not be removed" }, status: :unprocessable_entity
    end
  end
end
