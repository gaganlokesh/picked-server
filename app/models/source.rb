class Source < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  acts_as_followable

  has_many :articles, dependent: :destroy
end
