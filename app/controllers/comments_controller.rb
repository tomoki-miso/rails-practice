class CommentsController < ApplicationController
  before_action :set_commentable
  def new
    reply_comment = @commentable.comments.find_by(id: params[:reply_comment_id])
    return head :bad_request unless reply_comment

    @comment = @commentable.comments.build(reply_comment: reply_comment)
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
        @round = @group.rounds.find(params[:round_id])
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
