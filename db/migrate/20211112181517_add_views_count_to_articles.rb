class AddViewsCountToArticles < ActiveRecord::Migration[6.1]
  def self.up
    add_column :articles, :views_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :articles, :views_count
  end
end
