class Question < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: :user_id
  has_many :answers, dependent: :destroy
  validates :body, :title, presence: true
end
