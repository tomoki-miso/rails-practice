class Round < ApplicationRecord
  belongs_to :group
  has_many :preparation_completions, dependent: :destroy

  validates :number, uniqueness: { scope: :group_id }
  validates :number, presence: true
  validates :start_page, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :end_page, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validate :start_page_must_be_less_than_or_equal_to_end_page

  private

  def start_page_must_be_less_than_or_equal_to_end_page
    return if start_page.blank? || end_page.blank?
    return if start_page <= end_page
    errors.add("開始ページは終了ページ以下にしてください")
  end
end
