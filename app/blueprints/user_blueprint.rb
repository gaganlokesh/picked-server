class UserBlueprint < ApplicationBlueprint
  fields :id, :name, :email

  field :profile_image_url do |user, _|
    ImageOptimizer::S3.call(user.profile_image.path, width: 150, height: 150) if user.profile_image.present?
  end

  view :me do
    field :dismissed_actions
  end
end
