class SourceBlueprint < ApplicationBlueprint
  fields :id, :name, :website_url, :slug

  field :image_url do
    # FIXME: Returning dummy image URL for development purposes
    # Replace this with appropriate S3 URL
    "https://picked-dev.s3.ap-south-1.amazonaws.com/sources/logo/ycombinator-logo.png"
  end
end
