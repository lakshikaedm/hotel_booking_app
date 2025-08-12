class CreateUserModels < ActiveRecord::Migration[6.1]
  def change
    create_table :user_models do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.text :bio

      t.timestamps
    end
  end
end
