class CreateRounds < ActiveRecord::Migration[8.1]
  def change
    create_table :rounds do |t|
      t.references :group, null: false, foreign_key: true
      t.integer :number, null: false
      t.datetime :held_on
      t.integer :start_page, null: false
      t.integer :end_page, null: false

      t.timestamps
      t.index [ :group_id, :number ], unique: true
    end
  end
end
