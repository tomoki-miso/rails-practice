class CreateComments < ActiveRecord::Migration[8.1]
  def change
    create_table :comments do |t|
      t.references :group, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :reply_comment, foreign_key: { to_table: :comments }
      t.integer :page, null: false
      t.integer :kind, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
