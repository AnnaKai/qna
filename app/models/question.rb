class Question < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: :user_id
  has_many :answers, -> { preload(:question).joins(:question).order('answers.id = questions.best_answer_id desc') }, dependent: :destroy
  has_a :best_answer, class_name: "Answer", optional: true

  validates :body, :title, presence: true
end
