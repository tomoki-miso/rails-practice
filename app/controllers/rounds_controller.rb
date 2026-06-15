class RoundsController < ApplicationController
  before_action :set_group
  def new
    @round = @group.rounds.new(number:  @group.rounds.maximum(:number).to_i + 1)
  end

  def show
    @round = @group.rounds.includes(comments: :user).find(params[:id])
    @comment = Comment.new
  end


  def create
    @round = @group.rounds.new(round_params)
    respond_to do |format|
      if @round.save
        format.html { redirect_to [ @group, @round ], notice: "作成完了" }
        format.json { render :show, status: :created, location: [ @group, @round ] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @round.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def round_params
    params.expect(round: %i[number held_on start_page end_page])
  end

  def set_group
    @group = Group.find(params[:group_id])
  end
end
