class SourceBlueprint < ApplicationBlueprint
  fields :id, :name, :website_url, :slug

  field :image_url do
    # FIXME: Returning dummy image URL for development purposes
    # Replace this with appropriate S3 URL
    "https://picked-dev.s3.ap-south-1.amazonaws.com/sources/logo/ycombinator-logo.png"
  end

  view :extended do
    field :followers_count do |source, _|
      source.followers_count
    end

    field :is_following do |source, options|
      current_user = options[:current_user]
      if current_user.blank?
        false
      else
        current_user.following?(source)
      end
    end
  end
end
