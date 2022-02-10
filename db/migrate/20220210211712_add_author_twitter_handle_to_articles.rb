class AddAuthorTwitterHandleToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :author_twitter_uid, :string
    add_column :articles, :author_twitter_username, :string
  end
end
