class AddPagesToGroups < ActiveRecord::Migration[8.1]
  def change
    add_column :groups, :pages, :integer
  end
end
