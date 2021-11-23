class SourceBlueprint < ApplicationBlueprint
  fields :id, :name, :website_url, :slug, :description

  field :image_url do
    # FIXME: Returning dummy image URL for development purposes
    # Replace this with appropriate S3 URL
    "https://picked-dev.s3.ap-south-1.amazonaws.com/sources/logo/ycombinator-logo.png"
  end

  view :extended do
    field :followers_count do |source, _|
      source.followers_count
    end
    field :articles_count do |source, _|
      source.articles.size
    end
    field :total_views_count do |source, _|
      source.articles.sum(:views_count)
    end
  end

  view :with_user_context do
    field :is_following do |source, options|
      options[:current_user].following?(source)
    end
  end

  view :extended_with_user_context do
    include_view :extended
    include_view :with_user_context
  end
end
