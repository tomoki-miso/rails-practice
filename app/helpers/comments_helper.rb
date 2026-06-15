module CommentsHelper
  def comment_form_url(commentable)
    case commentable

    when Group
      group_comments_path(commentable)
    when Round
      group_round_comments_path(commentable.group, commentable)
    else
      raise ArgumentError, "Unsupported commentable: #{commentable.class.name}"
    end
  end

  def new_comment_path_for(parent_comment)
    commentable = parent_comment.commentable
    case commentable
    when Group
      new_group_comment_path(commentable, reply_comment_id: parent_comment.id)
    when Round
      new_group_round_comment_path(commentable.group, commentable, reply_comment_id: parent_comment.id)
    else
      raise ArgumentError, "Unsupported commentable: #{commentable.class.name}"
    end
  end
end
