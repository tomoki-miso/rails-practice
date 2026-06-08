class Group < ApplicationRecord
  has_many :rounds
  has_many :comments, dependent: :destryoy
  has_many :group_members, dependent: :destryoy
  has_many :users, through: :group_members, dependent: :destryoy
end
