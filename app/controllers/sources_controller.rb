class SourcesController < ApplicationController
  skip_before_action :doorkeeper_authorize!, only: [:index, :show, :articles]

  PER_PAGE = 15

  def index
    per_page = params[:per_page] || PER_PAGE

    sources = Source.all
      .order(:name)
      .page(params[:page].to_i)
      .per(per_page)

    render json: SourceBlueprint.render(sources), status: :ok
  end

  def show
    source = Source.friendly.find(params[:slug])
    render json: SourceBlueprint.render(
      source,
      current_user: current_user,
      view: :extended
    ), status: :ok
  end

  def articles
    source = Source.friendly.find(params[:source_slug])
    per_page = params[:per_page] || PER_PAGE

    articles = source.articles
      .includes(:bookmarks)
      .order(published_at: :desc)
      .page(params[:page].to_i)
      .per(per_page)

    render json: ArticleBlueprint.render(articles, current_user: current_user), status: :ok
  end

  def follow
    source = Source.friendly.find(params[:slug])
    current_user.follow(source)

    render json: { status: "success" }, status: :ok
  end

  def unfollow
    source = Source.friendly.find(params[:slug])
    current_user.stop_following(source)

    render json: { status: "success" }, status: :ok
  end
end
