require 'rails_helper'

RSpec.describe "Rounds", type: :request do
  fixtures :groups, :rounds

  let(:user) { User.create!(name: "テスト", email: "test@example.com", password: "password", confirmed_at: Time.current) }
  before { sign_in user }

  describe "GET /groups/:group_id/rounds/new" do
    it "new画面を表示する" do
      group = Group.create!(title: "輪読会")
      group.group_members.create!(user: user, role: :owner)
      get new_group_round_path(group)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("開催日の作成")
    end

    it "回数に次の開催回数を表示する" do
      group = groups(:reading_group)
      group.group_members.create!(user: user, role: :owner)

      get new_group_round_path(group)

      expect(response).to have_http_status(:ok)

      html = Nokogiri::HTML(response.body)

      expected_number = group.rounds.maximum(:number).to_i + 1

      number_field = html.at_css('input[type="hidden"][name="round[number]"]')

      expect(number_field).not_to be_nil
      expect(number_field["value"]).to eq expected_number.to_s
    end

    it "メンバーでない輪読会はホームにリダイレクトする" do
      group = Group.create!(title: "他人の輪読会")

      get new_group_round_path(group)

      expect(response).to redirect_to(root_path)
    end
  end
end
