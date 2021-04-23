class AddSourceIdToArticle < ActiveRecord::Migration[6.1]
  def change
    add_reference :articles, :source, null: false, foreign_key: true
  end
end
