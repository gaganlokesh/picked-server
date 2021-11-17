class CreateHiddenArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :hidden_articles do |t|
      t.references :article, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
