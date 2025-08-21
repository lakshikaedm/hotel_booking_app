class RoomModel < ApplicationRecord
  belongs_to :user_model
  has_many :reservation_models, dependent: :destroy

  has_one_attached :facility_image

  validates :title, :description, :address, presence: true
  validates :fee, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  scope :area_like, ->(city) {
    if city.present?
      where('LOWER(address) LIKE ?', "%#{city.downcase}%")
    end
  }

  scope :freeword, ->(q) {
    if q.present?
      where('LOWER(title) LIKE :p OR LOWER(description) LIKE :p', p: "%#{q.downcase}%")
    end
  }
end

