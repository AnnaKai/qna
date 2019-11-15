class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :image

  validates :name, presence: true
  validate :whitelisted_extension, :image_presence

  private

  def whitelisted_extension
    allowed_extensions = %w(png jpg jpeg)
    if image.attached?
      errors[:image] << 'wrong file extension' unless allowed_extensions.include?(image.filename.extension)
    end
  end

  def image_presence
    errors.add(:image, "Reward image can't be blank") unless image.attached?
  end
end
