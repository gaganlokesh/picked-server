class FeedsController < ApplicationController
  skip_before_action :doorkeeper_authorize!, only: [:show]

  FEED_TYPES = %w[discover following recommended].freeze
  PER_PAGE = 15

  def show
    per_page = params[:per_page]&.to_i || PER_PAGE
    stories = feed_stories
      .page(params[:page]&.to_i)
      .per(per_page)

    if current_user.present?
      render json: ArticleBlueprint.render(
        stories,
        current_user: current_user,
        view: :with_user_context
      ), status: :ok
    else
      render json: ArticleBlueprint.render(stories), status: :ok
    end
  end

  private

  def feed_stories
    feed_type = params[:type]

    if current_user.present? && FEED_TYPES.includes(feed_type)
      case feed_type
      when "following"
        following_stories
      when "recommended"
        recommended_stories
      else
        dicover_stories
      end
    else
      dicover_stories
    end
  end

  def following_stories
    current_user
      .following_sources
      .articles
      .order(published_at: :desc)
      .includes(:source, :bookmarks)
  end

  def recommended_stories
    Article.all
      .order(published_at: :desc)
      .includes(:source, :bookmarks)
  end

  def dicover_stories
    Article.all
      .order(published_at: :desc)
      .includes(:source)
  end
end
