class CreateReactions < ActiveRecord::Migration[6.1]
  def change
    create_table :reactions do |t|
      t.references :reactable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
