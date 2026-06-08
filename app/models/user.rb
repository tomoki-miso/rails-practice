class User < ApplicationRecord
  has_many :group_members, dependent: :destryoy
  has_many :preparation_completions, dependent: :destryoy
  has_many :groups, through: :group_members, dependent: :destryoy
  has_many :comments
end
