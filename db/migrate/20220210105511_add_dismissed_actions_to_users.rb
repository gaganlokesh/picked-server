class AddDismissedActionsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :dismissed_actions, :string, array: true, default: []
  end
end
