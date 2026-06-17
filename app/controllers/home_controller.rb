class HomeController < ApplicationController
  def index
    # 自分が参加している（招待されている）輪読会のみ表示する
    @group_members = current_user.group_members.includes(:group).order(created_at: :desc)
  end
end
