class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :article

  counter_culture :article
end
