class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, class_name: "Answer", optional: true
  belongs_to :author, class_name: "User", foreign_key: :user_id
  validates :body, :title, presence: true

  def sorted_answers
    best_answer_id ? answers.order("id = #{best_answer_id} desc") : answers
  end
end
