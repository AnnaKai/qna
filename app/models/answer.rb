class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User", foreign_key: :user_id

  validates :body, presence: true

  def best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
