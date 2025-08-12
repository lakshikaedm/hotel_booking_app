class RoomModel < ApplicationRecord
  belongs_to :user_model
  has_many :reservation_models, dependent: :destroy
end
