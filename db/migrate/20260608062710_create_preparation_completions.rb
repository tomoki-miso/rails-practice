class CreatePreparationCompletions < ActiveRecord::Migration[8.1]
  def change
    create_table :preparation_completions do |t|
      t.references :round, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :completed_at, null: false

      t.timestamps

      t.index [ :round_id, :user_id ], unique: true
    end
  end
end
