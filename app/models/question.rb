class Question < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: :user_id
  has_many :answers, dependent: :destroy

  has_many_attached :files

  validates :body, :title, presence: true
end
