class AllowNullRoundPages < ActiveRecord::Migration[8.1]
  def change
    change_column_null :rounds, :start_page, true
    change_column_null :rounds, :end_page, true
  end
end
