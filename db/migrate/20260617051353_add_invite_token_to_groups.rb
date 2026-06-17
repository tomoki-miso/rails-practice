class AddInviteTokenToGroups < ActiveRecord::Migration[8.1]
  def up
    add_column :groups, :invite_token, :string

    # 既存グループに招待コードを採番してから一意インデックスを張る
    Group.reset_column_information
    Group.where(invite_token: nil).find_each do |group|
      group.update_column(:invite_token, SecureRandom.base58(24))
    end

    add_index :groups, :invite_token, unique: true
  end

  def down
    remove_index :groups, :invite_token
    remove_column :groups, :invite_token
  end
end
