class Change < ActiveRecord::Migration
  def change
    rename_column :occupied_seats, :column_name, :seat_number
    rename_column :occupied_seats, :seat_coordinate, :seat_row
    add_column :occupied_seats, :updated_by, :string
  end
end
