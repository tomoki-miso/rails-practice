class Group < ApplicationRecord
  has_many :rounds
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :group_members, dependent: :destroy
  has_many :users, through: :group_members, dependent: :destroy
  has_one_attached :pdf
end
