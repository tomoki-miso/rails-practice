class Comment < ApplicationRecord
  belongs_to :group
  belongs_to :user
  belongs_to :reply_comment, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :reply_comment_id
end
