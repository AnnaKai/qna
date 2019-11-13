class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User", foreign_key: :user_id
  has_many :links, dependent: :destroy, as: :linkable

  has_one :reward
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  default_scope { order(best: :desc) }

  def best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.set_reward!(author)
    end
  end
end
