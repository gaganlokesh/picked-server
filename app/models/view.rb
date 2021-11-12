class View < ApplicationRecord
  belongs_to :article
  belongs_to :user

  counter_culture :article

  after_create_commit :update_article

  private

  def update_article
    article.on_views_update
  end
end
