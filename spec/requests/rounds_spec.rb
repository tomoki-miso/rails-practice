require 'rails_helper'

RSpec.describe "Rounds", type: :request do
  fixtures :groups, :rounds
  describe "GET /groups/:group_id/rounds/new" do
    it "new画面を表示する" do
      group = Group.create!(title: "輪読会")
      get new_group_round_path(group)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("開催日の作成")
    end

    it "回数に次の開催回数を表示する" do
      group = groups(:reading_group)

      get new_group_round_path(group)

      expect(response).to have_http_status(:ok)

      html = Nokogiri::HTML(response.body)

      expected_number = group.rounds.maximum(:number).to_i + 1

      number_field = html.at_css('input[type="hidden"][name="round[number]"]')

      expect(number_field).not_to be_nil
      expect(number_field["value"]).to eq expected_number.to_s
    end
  end
end
