class CreateRoomModels < ActiveRecord::Migration[6.1]
  def change
    create_table :room_models do |t|
      t.string :title
      t.text :description
      t.integer :fee
      t.string :address
      t.references :user_model, null: false, foreign_key: true

      t.timestamps
    end
  end
end
