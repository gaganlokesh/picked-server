class AddUniqueIndexOnUrlAndSourceIdToArticles < ActiveRecord::Migration[6.1]
  def change
    add_index :articles, [:url, :source_id], unique: true
  end
end
