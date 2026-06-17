require 'rails_helper'

RSpec.describe "Home", type: :request do
  let(:user) { User.create!(name: "テスト", email: "test@example.com", password: "password", confirmed_at: Time.current) }

  describe "GET /" do
    it "未ログインならログイン画面にリダイレクトする" do
      get root_path
      expect(response).to redirect_to(new_user_session_path)
    end

    context "ログイン済み" do
      before { sign_in user }

      it "参加中の輪読会のみ表示する" do
        joined = Group.create!(title: "参加している輪読会")
        joined.group_members.create!(user: user, role: :owner)
        Group.create!(title: "参加していない輪読会")

        get root_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("参加している輪読会")
        expect(response.body).not_to include("参加していない輪読会")
      end

      it "参加中の輪読会が無い場合はメッセージを表示する" do
        get root_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("参加中の輪読会はありません。")
      end
    end
  end
end
