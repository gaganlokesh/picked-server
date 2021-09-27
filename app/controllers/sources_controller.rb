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
    per_page = params[:per_page] || PER_PAGE
    source = Source.friendly.find(params[:source_slug])
    relation = source.articles

    relation = relation.includes(:bookmarks) if current_user.present?

    articles = relation
      .order(published_at: :desc)
      .page(params[:page].to_i)
      .per(per_page)

    if current_user.present?
      render json: ArticleBlueprint.render(
        articles,
        current_user: current_user,
        view: :with_user_context
      ), status: :ok
    else
      render json: ArticleBlueprint.render(articles), status: :ok
    end
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
