class ReservationModel < ApplicationRecord
  belongs_to :user_model
  belongs_to :room_model

  validates :check_in, :check_out, :guests, presence: true
  validates :guests, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validate :check_in_not_past
  validate :check_out_after_check_in

  before_validation :compute_total_price
  before_create :set_confirmed_at

  def nights
    return 0 unless check_in && check_out
    (check_out - check_in).to_i
  end

  private

  def compute_total_price
    return unless check_in && check_out && guests && room_model&.fee
    n = nights
    return if n <= 0
    self.total_price = n * guests * room_model.fee
  end

  def set_confirmed_at
    self.confirmed_at ||= Time.current
  end

  def check_in_not_past
    return unless check_in
    errors.add(:check_in, 'は本日以降の日付をご指定ください。') if check_in < Date.current
  end

  def check_out_after_check_in
    return unless check_in && check_out
    errors.add(:check_out, 'はチェックイン後の日付をご指定ください。') if check_out <= check_in
  end
end
