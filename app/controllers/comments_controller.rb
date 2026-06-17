class CommentsController < ApplicationController
  before_action :set_commentable
  def new
    reply_comment = @commentable.comments.find_by(id: params[:reply_comment_id])
    return head :bad_request unless reply_comment

    @comment = @commentable.comments.build(reply_comment: reply_comment)
  end

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

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
    @group = find_member_group(params[:group_id])
    return if @group.nil?

    @commentable =
      if params[:round_id]
        @round = @group.rounds.find(params[:round_id])
      else
        @group
      end
  end

  def parent_show_template
    "#{@commentable.class.name.tableize}/show"
  end

  def comment_params
    params.expect(comment: %i[kind content reply_comment_id page])
  end
end
