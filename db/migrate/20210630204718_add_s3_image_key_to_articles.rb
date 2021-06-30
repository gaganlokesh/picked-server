class AddS3ImageKeyToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :image_key, :string
  end
end
