class AddImagePlaceholderToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :image_placeholder, :text
  end
end
