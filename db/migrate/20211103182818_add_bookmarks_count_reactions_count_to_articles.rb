class AddBookmarksCountReactionsCountToArticles < ActiveRecord::Migration[6.1]
  def self.up
    add_column :articles, :bookmarks_count, :integer, null: false, default: 0

    add_column :articles, :reactions_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :articles, :bookmarks_count

    remove_column :articles, :reactions_count
  end
end
