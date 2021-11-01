class Article < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_users, through: :bookmarks, source: :user
  has_many :reactions, as: :reactable, dependent: :destroy

  belongs_to :source
end
