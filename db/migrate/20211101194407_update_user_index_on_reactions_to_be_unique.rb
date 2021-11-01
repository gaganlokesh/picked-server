class UpdateUserIndexOnReactionsToBeUnique < ActiveRecord::Migration[6.1]
  def change
    remove_index :reactions, :user_id

    add_index :reactions, [:user_id, :reactable_id, :reactable_type], unique: true
  end
end
