class AddRoomNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :room_number, :string
  end
end
