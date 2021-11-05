class AddScoreColumnsToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :score, :integer, default: 0
    add_column :articles, :hotness, :decimal, precision: 10, scale: 6, default: 0.0
    add_column :articles, :hotness_updated_at, :datetime
  end
end
