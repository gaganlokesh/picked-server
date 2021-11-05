class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :article

  counter_culture :article

  after_commit :update_article

  private

  def update_article
    article.on_bookmarks_update if article.respond_to?(:on_bookmarks_update)
  end
end
