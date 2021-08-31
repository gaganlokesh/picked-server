class SourcesController < ApplicationController
  skip_before_action :doorkeeper_authorize!, only: [:index, :articles]

  PER_PAGE = 15

  def index
    per_page = params[:per_page] || PER_PAGE

    sources = Source.all
      .order(:name)
      .page(params[:page].to_i)
      .per(per_page)

    render json: SourceBlueprint.render(sources), status: :ok
  end

  def articles
    source = Source.friendly.find(params[:source_slug])
    per_page = params[:per_page] || PER_PAGE

    articles = source.articles
      .order(published_at: :desc)
      .page(params[:page].to_i)
      .per(per_page)

    render json: ArticleBlueprint.render(articles), status: :ok
  end
end
