class CreateSources < ActiveRecord::Migration[6.1]
  def change
    create_table :sources do |t|
      t.string :name
      t.string :image_key
      t.string :website_url
      t.string :feed_url

      t.timestamps
    end
  end
end
