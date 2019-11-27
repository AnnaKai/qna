class Question < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: :user_id
  has_many :answers, dependent: :destroy
  include Linkable
  include Votable

  has_many_attached :files
  has_one :reward, dependent: :destroy

  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :body, :title, presence: true
end

