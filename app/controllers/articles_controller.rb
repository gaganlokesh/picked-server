require "openssl"

class ArticlesController < ApplicationController
  skip_before_action :doorkeeper_authorize!, only: [:index, :webhook]
  before_action :verify_signature, only: [:webhook]

  PER_PAGE = 15

  def index
    per_page = params[:per_page] || PER_PAGE
    relation = Article.all
      .order(published_at: :desc)
      .includes(:source)

    relation = relation.includes(:bookmarks) if current_user.present?

    articles = relation
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

  def bookmark
    article = Article.find(params[:id])
    Bookmark.create!(user: current_user, article: article)

    render json: { status: "success", message: "Bookmarked Article!" }, status: :created
  end

  def remove_bookmark
    article = Article.find(params[:id])
    bookmark = Bookmark.find_by(user: current_user, article: article)
    bookmark.destroy

    render json: { status: "success", message: "Bookmark removed!" }, status: :ok
  end

  def webhook
    if params[:sourceId] && !params[:items].empty?
      source = Source.friendly.find(params[:sourceId])

      params[:items].each do |feed_item|
        source.articles.create!(
          title: feed_item[:title],
          author_name: feed_item[:author],
          url: feed_item[:url],
          canonical_url: feed_item[:canonicalUrl],
          image_key: feed_item[:s3ImageKey],
          image_placeholder: feed_item[:imagePlaceholder],
          original_image_url: feed_item[:image],
          read_time: feed_item[:readTime],
          metered: feed_item[:metered],
          published_at: feed_item[:publishedAt]
        )
      end
    end

    render json: { message: "New feed items added" }, status: :ok
  end

  private

  def verify_signature
    signature = request.headers["x-hub-signature"]
    request_body = request.body.read
    hmac = OpenSSL::HMAC.hexdigest(
      "SHA256",
      Rails.application.credentials.feed_webhook_secret,
      request_body
    )
    calculated_signature = "sha256=#{hmac}"
    not_authorized if !signature || !ActiveSupport::SecurityUtils.secure_compare(calculated_signature, signature)
  end
end
