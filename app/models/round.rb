class Round < ApplicationRecord
  belongs_to :group
  has_many :preparation_completions, dependent: :destryoy
end
