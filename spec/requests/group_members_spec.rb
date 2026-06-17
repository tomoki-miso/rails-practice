require 'rails_helper'

RSpec.describe "GroupMembers", type: :request do
  let(:user) { User.create!(name: "テスト", email: "test@example.com", password: "password", confirmed_at: Time.current) }
  before { sign_in user }

  describe "POST /group_members" do
    it "有効な招待コードでメンバーとして参加する" do
      group = Group.create!(title: "招待コードで入る輪読会")

      expect {
        post group_members_path, params: { invite_token: group.invite_token }
      }.to change { group.group_members.count }.by(1)

      expect(response).to redirect_to(group_path(group))
      expect(group.users).to include(user)
      expect(group.group_members.find_by(user: user)).to be_member
    end

    it "無効な招待コードならホームに戻りアラートを出す" do
      expect {
        post group_members_path, params: { invite_token: "invalid" }
      }.not_to change(GroupMember, :count)

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("招待コードが無効です")
    end

    it "すでに参加済みなら二重登録しない" do
      group = Group.create!(title: "参加済み輪読会")
      group.group_members.create!(user: user, role: :owner)

      expect {
        post group_members_path, params: { invite_token: group.invite_token }
      }.not_to change(GroupMember, :count)

      expect(response).to redirect_to(group_path(group))
    end
  end
end
