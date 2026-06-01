class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.references :project, null: false, foreign_key: true
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.references :assignee, foreign_key: { to_table: :users }
      t.text :description
      t.timestamp :deadline

      t.timestamps
    end
  end
end
