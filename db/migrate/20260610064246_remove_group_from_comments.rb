class RemoveGroupFromComments < ActiveRecord::Migration[8.1]
  def change
    remove_reference :comments, :group, null: false, foreign_key: true
  end
end
