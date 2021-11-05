class Reaction < ApplicationRecord
  REACTABLE_TYPES = %w[Article].freeze

  belongs_to :reactable, polymorphic: true
  belongs_to :user

  counter_culture :reactable, column_name: "reactions_count"

  validates :reactable_type, inclusion: { in: REACTABLE_TYPES }
  validates :user_id, uniqueness: { scope: %i[reactable_id reactable_type] }

  after_commit :update_reactable

  private

  def update_reactable
    reactable.on_reactions_update if reactable.respond_to?(:on_reactions_update)
  end
end
