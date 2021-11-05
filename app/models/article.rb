class Article < ApplicationRecord
  DECAY_CONSTANT = 0.16

  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_users, through: :bookmarks, source: :user
  has_many :reactions, as: :reactable, dependent: :destroy

  belongs_to :source

  after_save_commit :async_update_score

  def on_reactions_update
    async_update_score
  end

  def on_bookmarks_update
    async_update_score
  end

  def async_update_score
    Articles::ScoreUpdateJob.perform_later(id)
  end

  def update_score
    score = reactions_count + bookmarks_count
    update_columns(
      score: score,
      hotness: calculate_hotness(score),
      hotness_updated_at: Time.current
    )
  end

  private

  def calculate_hotness(score)
    age = ((Time.current - created_at) / 3600).round(2) # hours
    (score / ((age + 2)**DECAY_CONSTANT)).round(6)
  end
end
