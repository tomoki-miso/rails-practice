class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects  do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description

      t.timestamps
    end

    add_index :projects, [ :organization_id, :name ], unique: true
  end
end
