class ArticleBlueprint < ApplicationBlueprint
  fields :id, :title, :url, :canonical_url, :image_placeholder, :read_time, :published_at

  field :reactions_count, name: :upvotes_count

  field :image_url do |article|
    ImageOptimizer::S3.call(article.image_key, width: 280, height: 200, enlarge: true)
  end

  view :with_user_context do
    field :is_bookmarked do |article, options|
      # FIXME: This operation will be expensive if there are a lot of bookmarked users for an article
      article.bookmarks.pluck(:user_id).include?(options[:current_user]&.id)
    end

    field :is_upvoted do |article, options|
      # FIXME: This operation will be expensive if there are a lot of reactions for an article
      article.reactions.pluck(:user_id).include?(options[:current_user]&.id)
    end
  end

  association :source, blueprint: SourceBlueprint
end
