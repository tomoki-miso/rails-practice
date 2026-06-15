class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  belongs_to :reply_comment, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :reply_comment_id, dependent: :nullify

  enum :kind, { question: 0, notice: 1, impression: 2, trivia: 3, other: 4 }

  validates :kind, presence: true
  validates :content, presence: true

  scope :top_level, -> { where(reply_comment_id: nil) }
end
