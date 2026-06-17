class GroupMembersController < ApplicationController
  # 招待コードを使って輪読会にメンバーとして参加する
  def create
    group = Group.find_by(invite_token: params[:invite_token])

    if group.nil?
      redirect_to root_path, alert: "招待コードが無効です"
    elsif group.users.exists?(current_user.id)
      redirect_to group_path(group), notice: "すでに参加しています"
    else
      group.group_members.create!(user: current_user, role: :member)
      redirect_to group_path(group), notice: "輪読会に参加しました"
    end
  end
end
