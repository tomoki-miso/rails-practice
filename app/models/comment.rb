class Comment < ApplicationRecord
  belongs_to :group
  belongs_to :user
  belongs_to :reply_comment, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :reply_comment_id, dependent: :nullify

  enum :kind, { question: 0, notice: 1, impression: 2, trivia: 3, other: 4 }
end
