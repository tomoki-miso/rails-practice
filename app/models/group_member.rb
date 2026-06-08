class GroupMember < ApplicationRecord
  belongs_to :group
  belongs_to :user

  enum :role, { owner: 0, member: 1 }

  validates :role, presence: true
  validates :user_id, uniqueness: { scope: :group_id }
end
