class Group < ApplicationRecord
  has_many :rounds
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :group_members, dependent: :destroy
  has_many :users, through: :group_members, dependent: :destroy
  has_one_attached :pdf

  after_commit :store_pdf_pages, on: %i[create update]

  private

  # 添付された PDF のページ数を解析して pages カラムに保存する。
  # update_column を使うことでバリデーション・コールバックの再発火を避ける。
  def store_pdf_pages
    return unless pdf.attached?

    pdf.blob.open do |file|
      update_column(:pages, PDF::Reader.new(file).page_count)
    end
  rescue PDF::Reader::MalformedPDFError, PDF::Reader::UnsupportedFeatureError
    # 解析できない PDF はページ数を保存しない（nil のまま）
  end
end
