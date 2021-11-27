class CreateOauthRequestTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :oauth_request_tokens do |t|
      t.string :token, null: false
      t.string :secret, null: false

      t.timestamps
    end

    add_index :oauth_request_tokens, :token
  end
end
