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
    if current_user.present?
      stories_for_feed_type
        .where.not(id: current_user.hidden_articles.pluck(:article_id))
        .includes(:source, :bookmarks, :reactions)
    else
      stories_for_feed_type.includes(:source)
    end
  end

  def stories_for_feed_type
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
      .order(hotness: :desc, created_at: :desc)
  end

  def recommended_stories
    following_sources_ids = current_user.following_sources.pluck(:id)

    Article
      .where.not(source_id: following_sources_ids)
      .order(hotness: :desc, created_at: :desc)
  end

  def recent_stories
    Article.all
      .order(created_at: :desc)
  end

  def top_stories
    Article.all
      .order(hotness: :desc, created_at: :desc)
  end
end
