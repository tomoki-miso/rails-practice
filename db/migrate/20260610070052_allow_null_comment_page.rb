class AllowNullCommentPage < ActiveRecord::Migration[8.1]
  def change
    change_column_null :comments, :page, true
  end
end
