class UserModel < ApplicationRecord
  has_secure_password
  has_many :room_models, dependent: :destroy
  has_many :reservation_models, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true
end
