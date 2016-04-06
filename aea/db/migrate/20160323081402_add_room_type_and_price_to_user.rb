class AddRoomTypeAndPriceToUser < ActiveRecord::Migration
  def change
    add_column :users, :room_type_id, :integer
    add_column :users, :price, :integer, :default => 0
  end
end
