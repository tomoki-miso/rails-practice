class Round < ApplicationRecord
  belongs_to :group
  has_many :preparation_completions, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :number, presence: true, uniqueness: { scope: :group_id }
  validates :held_on, presence: true
  validates :start_page, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :end_page, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  validate :start_page_must_be_less_than_or_equal_to_end_page
  validate :pages_within_group_total

  private

  def start_page_must_be_less_than_or_equal_to_end_page
    return if start_page.blank? || end_page.blank?
    return if start_page <= end_page
    errors.add(:base, "開始ページは終了ページ以下にしてください")
  end

  # グループの PDF ページ数を超えるページは指定できない。
  def pages_within_group_total
    max = group&.pages
    return if max.blank?

    if start_page.present? && start_page > max
      errors.add(:start_page, "は#{max}ページ以下にしてください")
    end
    if end_page.present? && end_page > max
      errors.add(:end_page, "は#{max}ページ以下にしてください")
    end
  end
end
