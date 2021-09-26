class Article < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_users, through: :bookmarks, source: :user

  belongs_to :source
end
