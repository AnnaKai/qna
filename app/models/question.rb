class Question < ApplicationRecord
  has_many :answers, dependent: :destroy # TODO: custom scope block with ordering
  belongs_to :author, class_name: "User", foreign_key: :user_id
  has_a :best_answer, class_name: "Answer", optional: true
  validates :body, :title, presence: true

  def sorted_answers
    best_answer_id ? answers.order("id = #{best_answer_id} desc") : answers
  end
end
