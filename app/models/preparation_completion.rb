class PreparationCompletion < ApplicationRecord
  belongs_to :round
  belongs_to :user

  validates :user_id, uniqueness: { scope: :round_id }
end
