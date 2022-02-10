class ArticlesController < ApplicationController
  skip_before_action :doorkeeper_authorize!, only: %i[index webhook]
  before_action :verify_request_signature, only: [:webhook]

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

  def hide
    article = HiddenArticle.new(article_id: params[:id], user_id: current_user&.id)

    if article.save
      render json: {}, status: :ok
    else
      render json: { status: "error", message: article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def webhook
    source = Source.friendly.find(webhook_params[:source_id])
    feed_items = webhook_params[:items].presence || []

    Articles::ImportFromFeedResponseJob.perform_later(source.id, feed_items) if feed_items.present?

    head :ok
  rescue ActiveRecord::RecordInvalid => e
    unprocessable_entity(e.message)
  end

  private

  def verify_request_signature
    algorithm, signature = request.headers["X-Hub-Signature"]&.split("=")
    if algorithm.present? && signature.present?
      expected_signature = OpenSSL::HMAC.hexdigest(
        algorithm,
        Rails.application.credentials.feed_webhook_secret,
        request.raw_post
      )

      return if ActiveSupport::SecurityUtils.secure_compare(signature, expected_signature)
    end

    not_authorized
  end

  def webhook_params
    params.deep_transform_keys!(&:underscore)

    allowed_params = [
      :source_id,
      {
        items: [
          :id,
          :title,
          :url,
          :canonical_url,
          :metered,
          :read_time,
          :published_at,
          :updated_at,
          {
            author: [
              :name,
              {
                twitter: %i[id name username]
              }
            ],
            image: [
              :url,
              :s3_image_key,
              :placeholder,
            ]
          }
        ]
      }
    ]

    params.permit(allowed_params)
  end
end
