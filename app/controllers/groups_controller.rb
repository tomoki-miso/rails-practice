class GroupsController < ApplicationController
  def new
    @group = Group.new
  end

  def show
    @group = Group.find(params[:id])
    @comment = Comment.new
  end

  def create
    @group = Group.new(group_params)
    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: "作成完了" }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def group_params
    params.expect(group: %i[title description pdf])
  end
end
