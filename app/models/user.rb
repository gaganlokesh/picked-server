class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable

  def self.from_external_authorizer(auth)
    where(provider: auth[:provider], uid: auth[:uid]).first_or_create do |user|
      user.email = auth[:info][:email]
      user.password = Devise.friendly_token[0, 16]
      user.name = auth[:info][:name]
      user.provider = auth[:provider]
      user.uid = auth[:uid]
    end
  end
end
