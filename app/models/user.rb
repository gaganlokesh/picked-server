class User < ApplicationRecord
  acts_as_follower

  # Include default devise modules. Others available are:
  # :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable

  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_articles, through: :bookmarks, source: :article
  has_many :reactions, dependent: :destroy
  has_many :views, dependent: :nullify
  has_many :read_articles, through: :views, source: :article
  has_many :hidden_articles, dependent: :destroy
  has_many :identities, dependent: :destroy

  mount_uploader :profile_image, ProfileImageUploader

  validates :provider, inclusion: { in: Authentication::Providers.all.map(&:to_s) }, allow_nil: true

  def self.from_external_authorizer(auth)
    where(email: auth[:info][:email]).first_or_create do |user|
      user.email = auth[:info][:email]
      user.password = Devise.friendly_token[0, 16]
      user.name = auth[:info][:name]
      user.remote_profile_image_url = auth[:info][:image]
      user.provider = auth[:provider]
      user.uid = auth[:uid]
    end
  end
end
