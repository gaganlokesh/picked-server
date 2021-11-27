class OauthRequestToken < ApplicationRecord
  validates :token, :secret, presence: true
end
