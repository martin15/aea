class CreateRoomTypesUserTypes < ActiveRecord::Migration
  def change
    create_table :room_types_user_types do |t|
      t.integer :room_type_id
      t.integer :user_type_id
      t.integer :price
      t.string  :country_type
      t.timestamps null: false
    end
  end
end
