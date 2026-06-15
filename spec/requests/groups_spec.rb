require 'rails_helper'

RSpec.describe "Groups", type: :request do
  fixtures :groups, :rounds

  describe "GET /new" do
    it "returns http success" do
      get "/groups/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /groups/:id" do
    it "紐づく開催日を回数・開催日・ページ範囲の表形式で表示する" do
      group = groups(:reading_group)
      round = rounds(:reading_round_one)

      get group_path(group)

      expect(response).to have_http_status(:ok)

      html = Nokogiri::HTML(response.body)
      expect(html.at_css("table")).not_to be_nil

      body = response.body
      expect(body).to include("第#{round.number}回")
      expect(body).to include(round.held_on.strftime('%Y年%m月%d日 %H:%M'))
      expect(body).to include("#{round.start_page} 〜 #{round.end_page}")
      expect(body).to include(group_round_path(group, round))
    end

    it "開催日が無い場合は未登録メッセージを表示する" do
      group = Group.create!(title: "開催日なし輪読会")

      get group_path(group)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("開催日はまだ登録されていません。")
    end
  end
end
