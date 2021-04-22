class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :url
      t.string :canonical_url
      t.string :author_name
      t.datetime :published_at
      t.integer :read_time, default: 0
      t.string :original_image_url
      t.boolean :metered, default: false

      t.timestamps
    end
  end
end
