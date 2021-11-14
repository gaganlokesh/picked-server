class Report < ApplicationRecord
  CATEGORIES = %w[spam harassment misinformation nsfw bug other].freeze
  REPORTABLE_TYPES = %w[Article].freeze

  belongs_to :reportable, polymorphic: true
  belongs_to :user

  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :reportable_type, inclusion: { in: REPORTABLE_TYPES }
  validates :reason, presence: { if: :reason_required? }

  private

  def reason_required?
    category == "other"
  end
end
