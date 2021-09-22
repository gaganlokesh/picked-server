class UpdateBookmarkIndexesToBeUnique < ActiveRecord::Migration[6.1]
  def change
    remove_index :bookmarks, :user_id
    remove_index :bookmarks, :article_id

    add_index :bookmarks, [:user_id, :article_id], unique: true
  end
end
