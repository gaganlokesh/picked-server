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
  has_many :reports, dependent: :destroy

  mount_uploader :profile_image, ProfileImageUploader

  validates :provider, inclusion: { in: Authentication::Providers.all.map(&:to_s) }, allow_nil: true
  validates :email, :username, presence: true, uniqueness: { case_sensitive: false }
  validates :username, length: { minimum: 3, maximum: 40 },
                       format: { with: /\A[a-zA-Z0-9_]+\z/, message: "can only contain alphabets, numbers and '_'" }

  def self.from_external_authorizer(auth)
    name = auth[:info][:name]
    email = auth[:info][:email]&.downcase
    username = "#{email.split('@').first.gsub(/[^0-9a-z ]/i, '')}_#{SecureRandom.hex(3)}"

    find_or_create_by!(email: email) do |user|
      user.email = email
      user.password = Devise.friendly_token[0, 16]
      user.name = name
      user.username = username
      user.remote_profile_image_url = auth[:info][:image]
      user.provider = auth[:provider]
      user.uid = auth[:uid]
    end
  end
end
