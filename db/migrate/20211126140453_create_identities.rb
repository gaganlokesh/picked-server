class CreateIdentities < ActiveRecord::Migration[6.1]
  def change
    create_table :identities do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :token
      t.string :secret
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :identities, [:provider, :uid], unique: true
    add_index :identities, [:provider, :user_id], unique: true
  end
end
