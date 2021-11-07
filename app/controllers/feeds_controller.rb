class FeedsController < ApplicationController
  skip_before_action :doorkeeper_authorize!, only: [:show]

  FEED_TYPES = %w[following recommended recent top].freeze
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

    if current_user.present? && feed_type == "following"
      following_stories
    elsif current_user.present? && feed_type == "recommended"
      recommended_stories
    elsif feed_type == "recent"
      recent_stories
    else
      top_stories
    end
  end

  def following_stories
    current_user
      .following_sources
      .articles
      .order(hotness: :desc)
      .includes(:source, :bookmarks)
  end

  def recommended_stories
    following_sources_ids = current_user.following_sources.pluck(:id)

    Article
      .where.not(source_id: following_sources_ids)
      .order(hotness: :desc)
      .includes(:source, :bookmarks)
  end

  def recent_stories
    Article.all
      .order(created_at: :desc)
      .includes(:source, :bookmarks)
  end

  def top_stories
    Article.all
      .order(hotness: :desc)
      .includes(:source, :bookmarks)
  end
end
