class Identity < ApplicationRecord
  belongs_to :user

  validates :provider, :uid, presence: true
  validates :provider, inclusion: { in: Authentication::Providers.all.map(&:to_s) }
  validates :uid, uniqueness: { scope: :provider }
  validates :user_id, presence: true, uniqueness: { scope: :provider }
end
