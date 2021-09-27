class ArticleBlueprint < ApplicationBlueprint
  fields :id, :title, :url, :canonical_url, :image_placeholder, :read_time, :published_at

  field :image_url do
    # FIXME: Returning dummy image URL for development purposes
    # Replace this with appropriate S3 URL
    "https://picked-dev.s3.ap-south-1.amazonaws.com/articles/main/5c35bb1c6af3d7171189b0ca0cebb65c.png"
  end

  view :with_user_context do
    field :is_bookmarked do |article, options|
      # FIXME: This operation will be expensive if there are a lot of bookmarked users for an article
      article.bookmarks.pluck(:user_id).include?(options[:current_user]&.id)
    end
  end

  association :source, blueprint: SourceBlueprint
end
