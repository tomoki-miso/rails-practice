class CreateGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :groups do |t|
      t.string :title, null: false
      t.string :description
      t.string :file_path
      t.integer :byte_size

      t.timestamps
    end
  end
end
