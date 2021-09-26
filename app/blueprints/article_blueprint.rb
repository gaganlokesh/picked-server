class ArticleBlueprint < ApplicationBlueprint
  fields :id, :title, :url, :canonical_url, :image_placeholder, :read_time, :published_at

  field :image_url do
    # FIXME: Returning dummy image URL for development purposes
    # Replace this with appropriate S3 URL
    "https://picked-dev.s3.ap-south-1.amazonaws.com/articles/main/5c35bb1c6af3d7171189b0ca0cebb65c.png"
  end

  field :is_bookmarked,
        if: ->(_, _, options) { options[:current_user].present? } do |article, options|
    article.bookmarks.pluck(:user_id).include?(options[:current_user]&.id)
  end

  association :source, blueprint: SourceBlueprint
end
