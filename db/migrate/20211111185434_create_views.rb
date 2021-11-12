class CreateViews < ActiveRecord::Migration[6.1]
  def change
    create_table :views do |t|
      t.integer :count, default: 1
      t.references :article, null: false, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
