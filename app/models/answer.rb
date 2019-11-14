class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User", foreign_key: :user_id
  include Linkable

  has_one :reward
  has_many_attached :files

  validates :body, presence: true

  default_scope { order(best: :desc) }

  def best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.reward&.update!(user: author)
    end
  end
end
