class CreateReservationModels < ActiveRecord::Migration[6.1]
  def change
    create_table :reservation_models do |t|
      t.date :check_in
      t.date :check_out
      t.integer :guests
      t.integer :total_price
      t.datetime :confirmed_at
      t.references :user_model, null: false, foreign_key: true
      t.references :room_model, null: false, foreign_key: true

      t.timestamps
    end
  end
end
