class AddDescriptionToSource < ActiveRecord::Migration[6.1]
  def change
    add_column :sources, :description, :text
  end
end
