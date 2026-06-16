class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :group_members, dependent: :destroy
  has_many :preparation_completions, dependent: :destroy
  has_many :groups, through: :group_members, dependent: :destroy
  has_many :comments

  validates :name, presence: true
end
