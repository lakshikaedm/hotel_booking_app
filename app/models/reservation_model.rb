class ReservationModel < ApplicationRecord
  belongs_to :user_model
  belongs_to :room_model
end
