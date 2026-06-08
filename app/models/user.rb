class User < ApplicationRecord
  has_many :group_members
  has_many :preparation_completions
  has_many :groups, through: :group_members
  has_many :comments
end
