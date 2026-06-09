class User < ApplicationRecord
  has_many :group_members, dependent: :destroy
  has_many :preparation_completions, dependent: :destroy
  has_many :groups, through: :group_members, dependent: :destroy
  has_many :comments
end
