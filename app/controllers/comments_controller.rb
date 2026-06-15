class CommentsController < ApplicationController
  before_action :set_commentable
  def new
    @comment = @commentable.comments.build(reply_comment_id: params[:reply_comment_id])
  end

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = User.find(1)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @commentable, notice: t("コメント投稿完了！") }
        format.turbo_stream
      else
        format.html { render parent_show_template, status: :unprocessable_entity }
        format.turbo_stream { render :create, status: :unprocessable_entity }
      end
    end
  end


  private
  def set_commentable
    @commentable =
      if params[:group_id] && params[:round_id]
        @group = Group.find(params[:group_id])
        @round = Round.find(params[:round_id])
      else
        @group = Group.find(params[:group_id])
      end
  end

  def parent_show_template
    "#{@commentable.class.name.tableize}/show"
  end

  def comment_params
    params.expect(comment: %i[kind content reply_comment_id page])
  end
end
